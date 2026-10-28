import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/config/app_config.dart';

class DioClient {
  DioClient._internal();
  static final DioClient instance = DioClient._internal();

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      // La generacion con el LLM puede tardar mas de un minuto.
      receiveTimeout: const Duration(seconds: 300),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );

  /// Token JWT solo en memoria.
  ///
  /// A propósito no se guarda en disco: al cerrar la app el token se pierde y
  /// el usuario tiene que iniciar sesión de nuevo.
  String? _accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  void init() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
}
