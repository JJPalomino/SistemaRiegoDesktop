// Script de verificacion manual contra el backend real.
//
// Uso:
//   1. Levanta el backend en http://127.0.0.1:8000
//   2. dart run tool/verify_api.dart
//
// Crea un usuario temporal (prueba.desktop+<timestamp>@example.com), una
// parcela y una siembra; recorre login, catalogo, recomendacion, historial y
// reporte PDF. Al final borra parcela y siembra. El usuario temporal debe
// eliminarse a mano de la base de datos.

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sistema_riego_desktop/features/auth/data/models/auth_models.dart';
import 'package:sistema_riego_desktop/features/crops/data/models/crop_models.dart';
import 'package:sistema_riego_desktop/features/history/data/models/history_models.dart';
import 'package:sistema_riego_desktop/features/parcels/data/models/parcela_models.dart';
import 'package:sistema_riego_desktop/features/recommendation/data/models/recommendation_models.dart';
import 'package:sistema_riego_desktop/features/siembras/data/models/siembra_models.dart';

const baseUrl = String.fromEnvironment('API_BASE',
    defaultValue: 'http://127.0.0.1:8000/api/v1');

Future<void> main() async {
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  final marca = DateTime.now().millisecondsSinceEpoch;
  final email = 'prueba.desktop+$marca@example.com';
  const password = 'prueba12345';

  void ok(String paso) => stdout.writeln('[OK] $paso');

  final registro = await dio.post('/usuarios/registro', data: {
    'nombre': 'Prueba Desktop',
    'email': email,
    'password': password,
  });
  ok('registro (${registro.statusCode})');

  final token = TokenResponse.fromJson(
      (await dio.post('/usuarios/login', data: {
    'email': email,
    'password': password,
  }))
          .data);
  dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
  ok('login -> usuario ${token.usuario.nombre} (${token.usuario.email})');

  final me = UserModel.fromJson((await dio.get('/usuarios/me')).data);
  ok('me -> ${me.id} ${me.nombre} activo=${me.activo}');

  final hortalizas = (await dio.get('/hortalizas/'))
      .data
      .map<Hortaliza>((e) => Hortaliza.fromJson(e as Map<String, dynamic>))
      .toList();
  ok('hortalizas -> ${hortalizas.length} (${hortalizas.first.nombre}, '
      '${hortalizas.first.duracionTotalDias} dias, '
      '${hortalizas.first.etapas.length} etapas)');

  final parcela = Parcela.fromJson((await dio.post('/parcelas/', data: {
    'nombre': 'Parcela de prueba',
    'latitud': 19.85,
    'longitud': -97.85,
    'altitud_msnm': 1900,
    'area_m2': 500,
    'textura_suelo': 'franco',
    'activa': true,
    'notas': 'creada por verify_api.dart',
  }))
      .data);
  ok('parcela -> ${parcela.id} (${parcela.texturaSuelo.apiValue})');

  final hoy = DateTime.now().toIso8601String().substring(0, 10);
  final siembra = Siembra.fromJson((await dio
          .post('/parcelas/${parcela.id}/siembras', data: SiembraCreate(
            hortalizaId: hortalizas.first.id,
            fechaSiembra: hoy,
            notas: 'siembra de prueba',
          ).toJson()))
      .data);
  ok('siembra -> ${siembra.id} ${siembra.fechaSiembra} '
      '(hortaliza ${siembra.nombreHortaliza})');

  final siembras = (await dio.get('/parcelas/${parcela.id}/siembras'))
      .data
      .map<Siembra>((e) => Siembra.fromJson(e as Map<String, dynamic>))
      .toList();
  ok('listado siembras -> ${siembras.length}, dias desde siembra '
      '${siembras.first.diasDesdeSiembra}');

  final recomendacion = RecomendacionResponse.fromJson((await dio.post(
    '/ai/recomendacion',
    data: SolicitudRecomendacion(
      siembraId: siembra.id,
      parcelaId: parcela.id,
    ).toJson(),
  ))
      .data);
  ok('recomendacion -> consulta ${recomendacion.idConsulta}, '
      'etapa ${recomendacion.etapa}, urgencia ${recomendacion.nivelUrgenciaMax}, '
      'alertas ${recomendacion.alertas.length}');

  final historial = (await dio.get('/ai/historial',
          queryParameters: {'siembra_id': siembra.id}))
      .data
      .map<ConsultaRecomendacionResumen>(
          (e) => ConsultaRecomendacionResumen.fromJson(e as Map<String, dynamic>))
      .toList();
  ok('historial -> ${historial.length} consulta(s), primera: '
      '${historial.first.nombreHortaliza} / ${historial.first.consultadoEn}');

  final detalle = ConsultaRecomendacionDetalle.fromJson(
      (await dio.get('/ai/historial/${historial.first.id}')).data);
  ok('detalle -> prompt ${detalle.prompt.length} chars, '
      'respuesta_json ${detalle.respuestaJson.length} claves');

  final pdf = await dio.get('/reportes/siembras/${siembra.id}.pdf',
      options: Options(responseType: ResponseType.bytes));
  final bytes = pdf.data as List<int>;
  final esPdf = bytes.length > 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46;
  ok('reporte pdf -> ${bytes.length} bytes, cabecera %PDF=$esPdf');

  await dio.delete('/parcelas/${parcela.id}/siembras/${siembra.id}');
  await dio.delete('/parcelas/${parcela.id}');
  ok('limpieza de parcela y siembra');

  stdout.writeln('\nUsuario temporal a eliminar de la BD: $email');
}
