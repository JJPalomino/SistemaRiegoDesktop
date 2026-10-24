/// Modelos del modulo de autenticacion.
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
class UserModel {
  const UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.activo,
    required this.createdAt,
  });

  final int id;
  final String nombre;
  final String email;
  final bool activo;
  final DateTime createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      activo: json['activo'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'email': email,
        'activo': activo,
        'created_at': createdAt.toIso8601String(),
      };
}

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json['email'] as String,
        password: json['password'] as String,
      );

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class TokenResponse {
  const TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.usuario,
  });

  final String accessToken;
  final String tokenType;
  final UserModel usuario;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json['access_token'] as String,
        tokenType: json['token_type'] as String? ?? 'bearer',
        usuario: UserModel.fromJson(json['usuario'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'usuario': usuario.toJson(),
      };
}
