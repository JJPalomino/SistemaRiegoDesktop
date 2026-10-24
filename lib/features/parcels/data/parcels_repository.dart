import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/parcels/data/models/parcela_models.dart';

class ParcelsRepository {
  ParcelsRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<List<Parcela>> getParcels() async {
    final response = await _dio.get('/parcelas/');
    return (response.data as List)
        .map((e) => Parcela.fromJson(e))
        .toList();
  }

  Future<Parcela> createParcela(ParcelaCreate data) async {
    final response = await _dio.post('/parcelas/', data: data.toJson());
    return Parcela.fromJson(response.data);
  }

  Future<Parcela> updateParcela(int id, ParcelaCreate data) async {
    final response = await _dio.put('/parcelas/$id', data: data.toJson());
    return Parcela.fromJson(response.data);
  }

  Future<void> deleteParcela(int id) async {
    await _dio.delete('/parcelas/$id');
  }
}
