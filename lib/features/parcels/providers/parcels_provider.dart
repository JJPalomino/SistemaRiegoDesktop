import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/parcels/data/models/parcela_models.dart';
import 'package:sistema_riego_desktop/features/parcels/data/parcels_repository.dart';

final parcelsRepositoryProvider = Provider<ParcelsRepository>((ref) {
  return ParcelsRepository();
});

final parcelsProvider =
    StateNotifierProvider<ParcelsNotifier, AsyncValue<List<Parcela>>>((ref) {
  final repo = ref.watch(parcelsRepositoryProvider);
  return ParcelsNotifier(repo);
});

class ParcelsNotifier extends StateNotifier<AsyncValue<List<Parcela>>> {
  ParcelsNotifier(this._repo) : super(const AsyncValue.loading()) {
    load();
  }
  final ParcelsRepository _repo;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final parcels = await _repo.getParcels();
      state = AsyncValue.data(parcels);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> create(ParcelaCreate data) async {
    await _repo.createParcela(data);
    await load();
  }

  Future<void> update(int id, ParcelaCreate data) async {
    await _repo.updateParcela(id, data);
    await load();
  }

  Future<void> delete(int id) async {
    await _repo.deleteParcela(id);
    await load();
  }
}
