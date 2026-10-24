import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/auth/data/auth_repository.dart';
import 'package:sistema_riego_desktop/features/auth/data/models/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier(this._repo) : super(const AsyncValue.data(null));
  final AuthRepository _repo;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await _repo.login(email, password);
      state = AsyncValue.data(token.usuario);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Registra la cuenta y deja la sesion iniciada con esas credenciales.
  Future<void> register(String nombre, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.register(nombre, email, password);
      final token = await _repo.login(email, password);
      state = AsyncValue.data(token.usuario);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Limpia el error previo (al cambiar entre ingresar y crear cuenta).
  void clearError() {
    if (state.hasError) state = const AsyncValue.data(null);
  }

  /// Recupera la sesion guardada (token JWT en almacenamiento seguro).
  ///
  /// Si el token ya no es valido se limpia para no dejar al usuario en un
  /// estado inconsistente.
  Future<void> restoreSession() async {
    if (!await _repo.hasSession()) {
      state = const AsyncValue.data(null);
      return;
    }
    try {
      final usuario = await _repo.me();
      state = AsyncValue.data(usuario);
    } catch (_) {
      await _repo.logout();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}
