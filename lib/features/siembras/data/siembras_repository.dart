import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/siembras/data/models/siembra_models.dart';

class SiembrasRepository {
  SiembrasRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<List<Siembra>> getSiembras(int parcelaId) async {
    final response = await _dio.get('/parcelas/$parcelaId/siembras');
    return (response.data as List).map((e) => Siembra.fromJson(e)).toList();
  }

  Future<Siembra> createSiembra(int parcelaId, SiembraCreate data) async {
    final response =
        await _dio.post('/parcelas/$parcelaId/siembras', data: data.toJson());
    return Siembra.fromJson(response.data);
  }

  Future<Siembra> updateSiembra(
      int parcelaId, int siembraId, SiembraCreate data) async {
    final response = await _dio.put(
      '/parcelas/$parcelaId/siembras/$siembraId',
      data: data.toJson(),
    );
    return Siembra.fromJson(response.data);
  }

  Future<void> deleteSiembra(int parcelaId, int siembraId) async {
    await _dio.delete('/parcelas/$parcelaId/siembras/$siembraId');
  }
}
