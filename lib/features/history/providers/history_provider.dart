import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/history/data/history_repository.dart';
import 'package:sistema_riego_desktop/features/history/data/models/history_models.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<ConsultaRecomendacionResumen>>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<ConsultaRecomendacionResumen>>> {
  HistoryNotifier(this._repo) : super(const AsyncValue.data([]));
  final HistoryRepository _repo;

  Future<void> load(int siembraId) async {
    state = const AsyncValue.loading();
    try {
      final history = await _repo.getHistory(siembraId);
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
