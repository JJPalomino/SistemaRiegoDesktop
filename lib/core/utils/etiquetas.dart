/// Textos legibles para valores que llegan del backend en minúsculas y sin
/// acentos (por ejemplo, `precaucion`). Se usan solo para mostrar al usuario;
/// la app sigue comparando con el valor original.
library;

/// Nombre correcto en español del nivel de urgencia.
String urgenciaEtiqueta(String? valor) {
  switch ((valor ?? '').trim().toLowerCase()) {
    case 'critica':
      return 'Crítica';
    case 'precaucion':
      return 'Precaución';
    case 'informativa':
      return 'Informativa';
    default:
      return 'No definida';
  }
}

/// Nombre de la etapa fenológica; si no hay dato, se indica explícitamente.
String etapaEtiqueta(String? etapa) {
  final texto = (etapa ?? '').trim();
  return texto.isEmpty ? 'Sin etapa definida' : texto;
}
