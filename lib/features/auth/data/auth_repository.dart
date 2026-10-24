import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_riego_desktop/core/constants/storage_keys.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/auth/data/models/auth_models.dart';

class AuthRepository {
  AuthRepository();
  final Dio _dio = DioClient.instance.dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<TokenResponse> login(String email, String password) async {
    final response = await _dio.post('/usuarios/login', data: {
      'email': email,
      'password': password,
    });
    final tokenResponse = TokenResponse.fromJson(response.data);
    await _storage.write(
        key: StorageKeys.accessToken, value: tokenResponse.accessToken);
    return tokenResponse;
  }

  /// Crea la cuenta en el backend. No inicia sesion por si sola: el llamador
  /// hace login despues para obtener el token.
  Future<UserModel> register(
      String nombre, String email, String password) async {
    final response = await _dio.post('/usuarios/registro', data: {
      'nombre': nombre,
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> me() async {
    final response = await _dio.get('/usuarios/me');
    return UserModel.fromJson(response.data);
  }

  Future<bool> hasSession() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: StorageKeys.accessToken);
  }
}
