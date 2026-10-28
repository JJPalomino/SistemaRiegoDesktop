import 'package:dio/dio.dart';

/// Traduce un error de red/Dio a un mensaje legible para el usuario.
///
/// El backend de FastAPI responde `{"detail": "..."}` en los errores de
/// negocio y `{"detail": [{"msg": "..."}]}` en los de validacion, por lo que
/// conviene extraer ese texto en lugar de mostrar el `DioException` completo.
String apiErrorMessage(Object error) {
  if (error is! DioException) return error.toString();

  final data = error.response?.data;
  if (data is Map && data['detail'] != null) {
    final detail = data['detail'];
    if (detail is String) return detail;
    if (detail is List) {
      final mensajes = detail
          .map((e) => e is Map ? (e['msg'] ?? e.toString()) : e.toString())
          .where((m) => m.isNotEmpty)
          .join('\n');
      if (mensajes.isNotEmpty) return mensajes;
    }
  }

  switch (error.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
      return 'No se pudo conectar con el servidor (${error.requestOptions.baseUrl}). '
          'Verifica que el servicio esté en ejecución.';
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.transformTimeout:
      return 'El servidor tardó demasiado en responder. Inténtalo de nuevo.';
    case DioExceptionType.badCertificate:
      return 'El certificado del servidor no es válido.';
    case DioExceptionType.cancel:
      return 'La solicitud fue cancelada.';
    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      if (status == 401) return 'Sesión expirada o credenciales incorrectas.';
      if (status == 403) return 'No tienes permisos para esta operación.';
      if (status == 404) return 'El recurso solicitado no existe.';
      if (status == 422) return 'Los datos enviados no son válidos.';
      return 'El servidor respondió con un error ($status).';
    case DioExceptionType.unknown:
      return 'Error de red: ${error.message ?? 'desconocido'}';
  }
}
