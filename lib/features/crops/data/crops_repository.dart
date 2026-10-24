import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:sistema_riego_desktop/features/crops/data/models/crop_models.dart';

class CropsRepository {
  CropsRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<List<Hortaliza>> getHortalizas() async {
    final response = await _dio.get('/hortalizas/');
    return (response.data as List).map((e) => Hortaliza.fromJson(e)).toList();
  }
}

final cropsProvider = FutureProvider<List<Hortaliza>>((ref) async {
  final repo = CropsRepository();
  return repo.getHortalizas();
});
