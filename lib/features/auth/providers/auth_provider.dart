import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/auth/data/auth_repository.dart';
import 'package:sistema_riego_desktop/features/auth/data/models/auth_models.dart';
import 'package:sistema_riego_desktop/features/history/providers/history_provider.dart';
import 'package:sistema_riego_desktop/features/parcels/providers/parcels_provider.dart';
import 'package:sistema_riego_desktop/features/recommendation/providers/recommendation_provider.dart';
import 'package:sistema_riego_desktop/features/siembras/providers/siembras_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo, ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier(this._repo, this._ref) : super(const AsyncValue.data(null));
  final AuthRepository _repo;
  final Ref _ref;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await _repo.login(email, password);
      _limpiarDatosDeSesion();
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
      _limpiarDatosDeSesion();
      state = AsyncValue.data(token.usuario);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Limpia el error previo (al cambiar entre ingresar y crear cuenta).
  void clearError() {
    if (state.hasError) state = const AsyncValue.data(null);
  }

  Future<void> logout() async {
    await _repo.logout();
    _limpiarDatosDeSesion();
    state = const AsyncValue.data(null);
  }

  /// Descarta los datos del usuario anterior para que no se muestren a quien
  /// inicie sesión después (parcela seleccionada, listas e historial).
  void _limpiarDatosDeSesion() {
    _ref.read(selectedParcelaIdProvider.notifier).state = null;
    _ref.invalidate(parcelsProvider);
    _ref.invalidate(siembrasProvider);
    _ref.invalidate(historyProvider);
    _ref.invalidate(recommendationProvider);
  }
}
