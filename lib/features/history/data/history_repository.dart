import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/history/data/models/history_models.dart';

class HistoryRepository {
  HistoryRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<List<ConsultaRecomendacionResumen>> getHistory(int siembraId) async {
    final response = await _dio.get('/ai/historial', queryParameters: {
      'siembra_id': siembraId,
    });
    return (response.data as List)
        .map((e) => ConsultaRecomendacionResumen.fromJson(e))
        .toList();
  }

  Future<ConsultaRecomendacionDetalle> getHistoryDetail(int consultaId) async {
    final response = await _dio.get('/ai/historial/$consultaId');
    return ConsultaRecomendacionDetalle.fromJson(response.data);
  }
}
