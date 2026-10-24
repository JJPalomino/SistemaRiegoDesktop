/// Modelos del flujo de recomendacion de riego.
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
class SolicitudRecomendacion {
  const SolicitudRecomendacion({
    this.siembraId,
    this.parcelaId,
    this.idHortaliza,
    this.diasSiembra,
    this.latitud = 19.2236,
    this.longitud = -97.8528,
    this.diasPronostico = 7,
  });

  final int? siembraId;
  final int? parcelaId;
  final int? idHortaliza;
  final int? diasSiembra;
  final double latitud;
  final double longitud;
  final int diasPronostico;

  factory SolicitudRecomendacion.fromJson(Map<String, dynamic> json) {
    return SolicitudRecomendacion(
      siembraId: json['siembra_id'] as int?,
      parcelaId: json['parcela_id'] as int?,
      idHortaliza: json['id_hortaliza'] as int?,
      diasSiembra: json['dias_siembra'] as int?,
      latitud: (json['latitud'] as num?)?.toDouble() ?? 19.2236,
      longitud: (json['longitud'] as num?)?.toDouble() ?? -97.8528,
      diasPronostico: json['dias_pronostico'] as int? ?? 7,
    );
  }

  Map<String, dynamic> toJson() => {
        if (siembraId != null) 'siembra_id': siembraId,
        if (parcelaId != null) 'parcela_id': parcelaId,
        if (idHortaliza != null) 'id_hortaliza': idHortaliza,
        if (diasSiembra != null) 'dias_siembra': diasSiembra,
        'latitud': latitud,
        'longitud': longitud,
        'dias_pronostico': diasPronostico,
      };
}

class Alerta {
  const Alerta({
    this.tipo = 'alerta',
    this.descripcion = '',
    this.nivel = 'informativa',
  });

  final String tipo;
  final String descripcion;
  final String nivel;

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
        tipo: json['tipo'] as String? ?? 'alerta',
        descripcion: json['descripcion'] as String? ?? '',
        nivel: json['nivel'] as String? ?? 'informativa',
      );

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'descripcion': descripcion,
        'nivel': nivel,
      };
}

class ClimaPronostico {
  const ClimaPronostico({
    required this.latitud,
    required this.longitud,
    this.fechaInicioPronostico,
    this.fechaFinPronostico,
    this.diasPronostico = 0,
    this.precipitacionMm = 0.0,
    this.evapotranspiracionRefMm = 0.0,
    this.tempMaxC,
    this.tempMinC,
    this.temperaturaBulboSecoC,
    this.velocidadVientoKmh,
    this.probabilidadPrecipitacionPct,
    this.radiacionSolarWm2,
    this.radiacionSolarMjM2Dia,
    this.humedadRelativaPct,
    this.puntoRocioC,
    this.temperaturaSueloC,
    this.humedadSueloPct,
    this.coberturaNubesPct,
    this.fuente = 'open_meteo',
  });

  final double latitud;
  final double longitud;
  final String? fechaInicioPronostico;
  final String? fechaFinPronostico;
  final int diasPronostico;
  final double precipitacionMm;
  final double evapotranspiracionRefMm;
  final double? tempMaxC;
  final double? tempMinC;
  final double? temperaturaBulboSecoC;
  final double? velocidadVientoKmh;
  final double? probabilidadPrecipitacionPct;
  final double? radiacionSolarWm2;
  final double? radiacionSolarMjM2Dia;
  final double? humedadRelativaPct;
  final double? puntoRocioC;
  final double? temperaturaSueloC;
  final double? humedadSueloPct;
  final double? coberturaNubesPct;
  final String fuente;

  factory ClimaPronostico.fromJson(Map<String, dynamic> json) {
    return ClimaPronostico(
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      fechaInicioPronostico: json['fecha_inicio_pronostico'] as String?,
      fechaFinPronostico: json['fecha_fin_pronostico'] as String?,
      diasPronostico: json['dias_pronostico'] as int? ?? 0,
      precipitacionMm: (json['precipitacion_mm'] as num?)?.toDouble() ?? 0.0,
      evapotranspiracionRefMm:
          (json['evapotranspiracion_ref_mm'] as num?)?.toDouble() ?? 0.0,
      tempMaxC: (json['temp_max_c'] as num?)?.toDouble(),
      tempMinC: (json['temp_min_c'] as num?)?.toDouble(),
      temperaturaBulboSecoC:
          (json['temperatura_bulbo_seco_c'] as num?)?.toDouble(),
      velocidadVientoKmh: (json['velocidad_viento_kmh'] as num?)?.toDouble(),
      probabilidadPrecipitacionPct:
          (json['probabilidad_precipitacion_pct'] as num?)?.toDouble(),
      radiacionSolarWm2: (json['radiacion_solar_wm2'] as num?)?.toDouble(),
      radiacionSolarMjM2Dia:
          (json['radiacion_solar_mj_m2_dia'] as num?)?.toDouble(),
      humedadRelativaPct: (json['humedad_relativa_pct'] as num?)?.toDouble(),
      puntoRocioC: (json['punto_rocio_c'] as num?)?.toDouble(),
      temperaturaSueloC: (json['temperatura_suelo_c'] as num?)?.toDouble(),
      humedadSueloPct: (json['humedad_suelo_pct'] as num?)?.toDouble(),
      coberturaNubesPct: (json['cobertura_nubes_pct'] as num?)?.toDouble(),
      fuente: json['fuente'] as String? ?? 'open_meteo',
    );
  }

  Map<String, dynamic> toJson() => {
        'latitud': latitud,
        'longitud': longitud,
        'fecha_inicio_pronostico': fechaInicioPronostico,
        'fecha_fin_pronostico': fechaFinPronostico,
        'dias_pronostico': diasPronostico,
        'precipitacion_mm': precipitacionMm,
        'evapotranspiracion_ref_mm': evapotranspiracionRefMm,
        'temp_max_c': tempMaxC,
        'temp_min_c': tempMinC,
        'temperatura_bulbo_seco_c': temperaturaBulboSecoC,
        'velocidad_viento_kmh': velocidadVientoKmh,
        'probabilidad_precipitacion_pct': probabilidadPrecipitacionPct,
        'radiacion_solar_wm2': radiacionSolarWm2,
        'radiacion_solar_mj_m2_dia': radiacionSolarMjM2Dia,
        'humedad_relativa_pct': humedadRelativaPct,
        'punto_rocio_c': puntoRocioC,
        'temperatura_suelo_c': temperaturaSueloC,
        'humedad_suelo_pct': humedadSueloPct,
        'cobertura_nubes_pct': coberturaNubesPct,
        'fuente': fuente,
      };
}

class RecomendacionResponse {
  const RecomendacionResponse({
    required this.idHortaliza,
    required this.nombreHortaliza,
    required this.diasSiembra,
    required this.clima,
    required this.recomendacionRiego,
    required this.recomendacionGeneral,
    required this.generadoEn,
    this.etapa,
    this.alertas = const [],
    this.nivelUrgenciaMax = 'informativa',
    this.modeloLlm,
    this.demoMode = false,
    this.idConsulta,
  });

  final int idHortaliza;
  final String nombreHortaliza;
  final String? etapa;
  final int diasSiembra;
  final ClimaPronostico clima;
  final String recomendacionRiego;
  final String recomendacionGeneral;
  final List<Alerta> alertas;
  final String nivelUrgenciaMax;
  final String? modeloLlm;
  final bool demoMode;
  final int? idConsulta;
  final DateTime generadoEn;

  factory RecomendacionResponse.fromJson(Map<String, dynamic> json) {
    return RecomendacionResponse(
      idHortaliza: json['id_hortaliza'] as int,
      nombreHortaliza: json['nombre_hortaliza'] as String,
      etapa: json['etapa'] as String?,
      diasSiembra: json['dias_siembra'] as int? ?? 0,
      clima: ClimaPronostico.fromJson(json['clima'] as Map<String, dynamic>),
      recomendacionRiego: json['recomendacion_riego'] as String,
      recomendacionGeneral: json['recomendacion_general'] as String,
      alertas: (json['alertas'] as List<dynamic>?)
              ?.map((e) => Alerta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nivelUrgenciaMax: json['nivel_urgencia_max'] as String? ?? 'informativa',
      modeloLlm: json['modelo_llm'] as String?,
      demoMode: json['demo_mode'] as bool? ?? false,
      idConsulta: json['id_consulta'] as int?,
      generadoEn: json['generado_en'] == null
          ? DateTime.now()
          : DateTime.parse(json['generado_en'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_hortaliza': idHortaliza,
        'nombre_hortaliza': nombreHortaliza,
        'etapa': etapa,
        'dias_siembra': diasSiembra,
        'clima': clima.toJson(),
        'recomendacion_riego': recomendacionRiego,
        'recomendacion_general': recomendacionGeneral,
        'alertas': alertas.map((a) => a.toJson()).toList(),
        'nivel_urgencia_max': nivelUrgenciaMax,
        'modelo_llm': modeloLlm,
        'demo_mode': demoMode,
        'id_consulta': idConsulta,
        'generado_en': generadoEn.toIso8601String(),
      };
}
