import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/features/recommendation/data/models/recommendation_models.dart';
import 'package:sistema_riego_desktop/features/recommendation/data/recommendation_repository.dart';

final recommendationRepositoryProvider = Provider<RecommendationRepository>((ref) {
  return RecommendationRepository();
});

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, AsyncValue<RecomendacionResponse?>>((ref) {
  final repo = ref.watch(recommendationRepositoryProvider);
  return RecommendationNotifier(repo);
});

class RecommendationNotifier extends StateNotifier<AsyncValue<RecomendacionResponse?>> {
  RecommendationNotifier(this._repo) : super(const AsyncValue.data(null));
  final RecommendationRepository _repo;

  Future<void> getRecommendation(SolicitudRecomendacion solicitud) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.getRecommendation(solicitud);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
