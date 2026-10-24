import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/recommendation/data/models/recommendation_models.dart';

class RecommendationRepository {
  RecommendationRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<RecomendacionResponse> getRecommendation(
      SolicitudRecomendacion solicitud) async {
    final response = await _dio.post('/ai/recomendacion', data: solicitud.toJson());
    return RecomendacionResponse.fromJson(response.data);
  }
}
