# Integración de tecnologías de monitoreo para la optimización del riego en microparcelas agrícolas

Documentación técnica de la aplicación de escritorio. Aplicación: **Sistema de
Riego**.

Cliente de escritorio en Flutter que consume la API REST del sistema. Permite
iniciar sesión con JWT, administrar parcelas y siembras, solicitar
recomendaciones de riego, consultar el historial y descargar el reporte PDF de
una siembra.

## Módulos

| Módulo | Descripción |
| --- | --- |
| Autenticación | Registro de cuenta, inicio y cierre de sesión con JWT. La sesión termina al cerrar la app. |
| Parcelas | Alta, edición y baja de microparcelas (textura de suelo, coordenadas, área). |
| Siembras | Ciclos de cultivo por parcela, con catálogo de hortalizas. Permite editar la fecha de cosecha para cerrar un ciclo y registrar el siguiente. |
| Recomendación | Genera una recomendación de riego para una siembra existente y muestra los datos del pronóstico de Open-Meteo (temperaturas, precipitación, humedad, viento, radiación, etc.) con los que se calculó. |
| Historial | Consultas de recomendación registradas para cada siembra. |
| Reportes | Descarga del PDF con la última recomendación de la siembra. |

La parcela seleccionada se comparte entre los módulos, por lo que al elegirla en
Siembras queda preseleccionada en Recomendación, Historial y Reportes.

## Arquitectura

| Capa | Tecnología | Función |
| --- | --- | --- |
| Presentación | Flutter / Dart (Windows) | Interfaz del productor |
| Aplicación | Python / FastAPI | Reglas de negocio y orquestación |
| Datos | PostgreSQL | Persistencia e historial |

La aplicación se comunica con el servidor mediante la dirección configurada en
`lib/core/config/app_config.dart`.

## Estructura

```
lib/
  core/            # configuración, red (Dio + JWT), router, tema y mensajes de error
  features/
    auth/          # login, sesión y modelos de usuario
    parcels/       # parcelas
    siembras/      # siembras y catálogo de hortalizas
    recommendation/# recomendaciones de riego
    history/       # historial de consultas
    reports/       # descarga de PDF
    home/          # layout de escritorio (NavigationRail)
assets/images/     # imágenes de la interfaz (fondo del login)
installer/         # generador del instalador
tool/              # utilidades de verificación
```

## Notas

- El token JWT se guarda **solo en memoria** (`DioClient`): al cerrar la app la
  sesión termina. El botón de cerrar sesión hace lo mismo sin salir del
  programa y descarta los datos del usuario anterior (parcela seleccionada,
  listas, historial).
- El backend recorre una cadena de modelos de lenguaje: si uno agota su cuota o
  está saturado, pasa al siguiente. El historial guarda el modelo que realmente
  respondió.
- El backend no permite dos ciclos traslapados en la misma parcela. Para
  registrar una siembra nueva primero se cierra la anterior con su fecha de
  cosecha; si se intenta sin cerrarla, la app muestra el motivo devuelto por la
  API.
- En Recomendación el interruptor «Usar una siembra registrada» elige entre dos
  formas de calcular: con una siembra (queda en su historial) o **rápida**, donde
  se piden hortaliza y días desde la siembra. En modo rápido se puede indicar
  una parcela solo para tomar sus coordenadas en el pronóstico; sin parcela se
  usa el centro de Tlatlauquitepec y la recomendación no se guarda en el
  historial de ninguna siembra.
- Los modelos de datos están escritos a mano, sin generadores de código.
- La interfaz usa una paleta agrícola (verdes de campo, amarillo de cosecha y
  tonos de tierra) definida en `lib/core/theme/app_theme.dart`.
- El login muestra una imagen a pantalla completa: `assets/images/login_background.jpg`.

## Estado legal

Obra: **Integración de tecnologías de monitoreo para la optimización del riego
en microparcelas agrícolas**.

Autor: **Juan José Palomino Jacobo**, quien conserva los derechos morales
irrenunciables sobre la obra.

Titular de los derechos patrimoniales: **Instituto Tecnológico Superior de
Teziutlán**, por cesión otorgada conforme a la Ley Federal del Derecho de Autor.

El detalle de la cesión se encuentra en el archivo `LICENCIA` de este
repositorio.
