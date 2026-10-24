import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/core/network/dio_client.dart';
import 'package:file_saver/file_saver.dart';

class ReportsRepository {
  ReportsRepository();
  final Dio _dio = DioClient.instance.dio;

  Future<void> downloadReport(int siembraId) async {
    final response = await _dio.get(
      '/reportes/siembras/$siembraId.pdf',
      options: Options(responseType: ResponseType.bytes),
    );
    await FileSaver.instance.saveFile(
      // `ext` agrega la extension; el nombre no debe incluirla.
      name: 'reporte_siembra_$siembraId',
      bytes: response.data,
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
  }
}
