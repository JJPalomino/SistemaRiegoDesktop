# Sistema de Riego — Aplicación de escritorio (Windows)

Cliente de escritorio en Flutter que consume la API REST del **Sistema de Riego**
(backend FastAPI del proyecto `sistema_riego`). Permite iniciar sesión con JWT,
administrar parcelas y siembras, solicitar recomendaciones de riego, consultar
el historial y descargar el reporte PDF de una siembra.

## Módulos

| Módulo | Descripción |
| --- | --- |
| Autenticación | Registro de cuenta, login con JWT, sesión persistente y cierre de sesión. |
| Parcelas | Alta, edición y baja de microparcelas (textura de suelo, coordenadas, área). |
| Siembras | Ciclos de cultivo por parcela, con catálogo de hortalizas. Permite editar la fecha de cosecha para cerrar un ciclo y registrar el siguiente. |
| Recomendación | Genera una recomendación de riego para una siembra existente. |
| Historial | Consultas de recomendación registradas para cada siembra. |
| Reportes | Descarga del PDF con la última recomendación de la siembra. |

La parcela seleccionada se comparte entre los módulos, por lo que al elegirla en
Siembras queda preseleccionada en Recomendación, Historial y Reportes.

## Requisitos

- Windows 10 o superior (64 bits).
- Backend del Sistema de Riego en ejecución (por defecto `http://127.0.0.1:8000`).
- Para compilar: Flutter 3.x con el soporte de Windows habilitado
  (`flutter config --enable-windows-desktop`) y Visual Studio con las
  herramientas de C++ para escritorio.

## Configuración del backend

La URL de la API se define en `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String apiPrefix = '/api/v1';
}
```

Si el backend se publica en otro equipo o puerto, cambia `baseUrl` y vuelve a
compilar. El backend debe permitir CORS para el origen de la app.

## Ejecutar en desarrollo

```powershell
flutter pub get
flutter run -d windows
```

## Compilar la aplicación

```powershell
flutter build windows
```

El ejecutable queda en
`build\windows\x64\runner\Release\sistema_riego_desktop.exe`.

## Generar el instalador

El instalador se construye con [Inno Setup 6](https://jrsoftware.org/isinfo.php)
(instalación por usuario, sin permisos de administrador):

```powershell
winget install JRSoftware.InnoSetup
powershell -ExecutionPolicy Bypass -File installer\build_installer.ps1
```

El script compila la versión Release y genera:

```
dist\SistemaRiego-Setup-1.0.0.exe
```

Para cambiar la versión, edita `MyAppVersion` en `installer\sistema_riego.iss`.

## Instalar

1. Ejecuta `dist\SistemaRiego-Setup-1.0.0.exe`.
2. Sigue el asistente (instala en `%LOCALAPPDATA%\Programs\Sistema de Riego`).
3. Abre **Sistema de Riego** desde el menú Inicio o el acceso directo del
   escritorio e inicia sesión con un usuario registrado en el backend.

Para desinstalar: **Configuración → Aplicaciones → Sistema de Riego**, o el
acceso **Desinstalar Sistema de Riego** del menú Inicio.

## Verificación contra la API real

`tool/verify_api.dart` recorre el flujo completo (registro, login, catálogo,
parcela, siembra, recomendación, historial y PDF) usando los mismos modelos de la
app. Crea un usuario temporal `prueba.desktop+<timestamp>@example.com` que debe
eliminarse de la base de datos al terminar:

```powershell
dart run tool/verify_api.dart
# contra otro servidor:
dart run -DAPI_BASE=http://127.0.0.1:8001/api/v1 tool/verify_api.dart
```

## Estructura

```
lib/
  core/            # configuración, red (Dio + JWT), router, mensajes de error
  features/
    auth/          # login, sesión y modelos de usuario
    parcels/       # parcelas
    siembras/      # siembras y catálogo de hortalizas
    recommendation/# recomendaciones de riego
    history/       # historial de consultas
    reports/       # descarga de PDF
    home/          # layout de escritorio (NavigationRail)
installer/         # script de Inno Setup y generador del instalador
tool/              # utilidades de verificación
```

## Notas

- La app usa `flutter_secure_storage` para guardar el token JWT y restaurar la
  sesión al abrirla; si el token expiró, regresa al login.
- El endpoint de recomendaciones depende del modelo de Gemini configurado en el
  backend (`GEMINI_MODEL`). Los modelos con razonamiento pueden tardar más de un
  minuto: la app espera hasta 5 minutos y el backend usa `GEMINI_TIMEOUT_S`
  (180 s por defecto). Si el modelo fue retirado, la cuota se agotó o Gemini no
  responde, la API devuelve `502 No se pudo generar la recomendacion` y la app
  muestra ese mensaje.
- El backend no permite dos ciclos traslapados en la misma parcela. Para
  registrar una siembra nueva primero cierra la anterior con su fecha de
  cosecha (botón de editar en Siembras); si se intenta sin cerrarla, la app
  muestra el motivo devuelto por la API.
- Los modelos de datos están escritos a mano (sin `build_runner`), por lo que no
  hace falta ejecutar generadores de código.
