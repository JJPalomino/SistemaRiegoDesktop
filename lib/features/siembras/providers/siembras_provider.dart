import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/siembras/data/models/siembra_models.dart';
import 'package:sistema_riego_desktop/features/siembras/data/siembras_repository.dart';

final siembrasRepositoryProvider = Provider<SiembrasRepository>((ref) {
  return SiembrasRepository();
});

final selectedParcelaIdProvider = StateProvider<int?>((ref) => null);

final siembrasProvider =
    StateNotifierProvider<SiembrasNotifier, AsyncValue<List<Siembra>>>((ref) {
  final repo = ref.watch(siembrasRepositoryProvider);
  final parcelaId = ref.watch(selectedParcelaIdProvider);
  return SiembrasNotifier(repo, parcelaId);
});

class SiembrasNotifier extends StateNotifier<AsyncValue<List<Siembra>>> {
  SiembrasNotifier(this._repo, this._parcelaId)
      : super(const AsyncValue.data([])) {
    if (_parcelaId != null) load();
  }
  final SiembrasRepository _repo;
  final int? _parcelaId;

  Future<void> load() async {
    if (_parcelaId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final siembras = await _repo.getSiembras(_parcelaId);
      state = AsyncValue.data(siembras);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create(SiembraCreate data) async {
    if (_parcelaId == null) return;
    await _repo.createSiembra(_parcelaId, data);
    await load();
  }

  Future<void> update(int siembraId, SiembraCreate data) async {
    if (_parcelaId == null) return;
    await _repo.updateSiembra(_parcelaId, siembraId, data);
    await load();
  }

  Future<void> delete(int siembraId) async {
    if (_parcelaId == null) return;
    await _repo.deleteSiembra(_parcelaId, siembraId);
    await load();
  }
}
