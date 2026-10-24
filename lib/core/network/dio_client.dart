import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_riego_desktop/core/config/app_config.dart';
import 'package:sistema_riego_desktop/core/constants/storage_keys.dart';

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

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void init() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: StorageKeys.accessToken);
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
