/// Modelos del catalogo de hortalizas.
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
class EtapaHortaliza {
  const EtapaHortaliza({
    required this.id,
    required this.hortalizaId,
    required this.nombreEtapa,
    required this.diaInicio,
    required this.diaFin,
    this.tempCriticaEtapaC,
    this.riegoFrecuenciaDias,
    this.notasEtapa,
  });

  final int id;
  final int hortalizaId;
  final String nombreEtapa;
  final int diaInicio;
  final int diaFin;
  final double? tempCriticaEtapaC;
  final int? riegoFrecuenciaDias;
  final String? notasEtapa;

  factory EtapaHortaliza.fromJson(Map<String, dynamic> json) {
    return EtapaHortaliza(
      id: json['id'] as int,
      hortalizaId: json['hortaliza_id'] as int? ?? 0,
      nombreEtapa: json['nombre_etapa'] as String,
      diaInicio: json['dia_inicio'] as int,
      diaFin: json['dia_fin'] as int,
      tempCriticaEtapaC: (json['temp_critica_etapa_c'] as num?)?.toDouble(),
      riegoFrecuenciaDias: json['riego_frecuencia_dias'] as int?,
      notasEtapa: json['notas_etapa'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hortaliza_id': hortalizaId,
        'nombre_etapa': nombreEtapa,
        'dia_inicio': diaInicio,
        'dia_fin': diaFin,
        'temp_critica_etapa_c': tempCriticaEtapaC,
        'riego_frecuencia_dias': riegoFrecuenciaDias,
        'notas_etapa': notasEtapa,
      };
}

class Hortaliza {
  const Hortaliza({
    required this.id,
    required this.nombre,
    required this.tempMinC,
    required this.tempMaxC,
    required this.tempIdealC,
    required this.humedadSueloMinPct,
    required this.humedadSueloMaxPct,
    required this.requerimientoAguaSemanalMm,
    required this.duracionTotalDias,
    this.nombreCientifico,
    this.radiacionSolarMinWm2,
    this.radiacionSolarMaxWm2,
    this.altitudMinMsnm,
    this.altitudMaxMsnm,
    this.sensibilidadHeladas,
    this.sensibilidadHumedadExcesiva,
    this.sensibilidadViento,
    this.notasGenerales,
    this.etapas = const [],
  });

  final int id;
  final String nombre;
  final String? nombreCientifico;
  final double tempMinC;
  final double tempMaxC;
  final double tempIdealC;
  final double humedadSueloMinPct;
  final double humedadSueloMaxPct;
  final double requerimientoAguaSemanalMm;
  final double? radiacionSolarMinWm2;
  final double? radiacionSolarMaxWm2;
  final double? altitudMinMsnm;
  final double? altitudMaxMsnm;
  final String? sensibilidadHeladas;
  final String? sensibilidadHumedadExcesiva;
  final String? sensibilidadViento;
  final int duracionTotalDias;
  final String? notasGenerales;
  final List<EtapaHortaliza> etapas;

  factory Hortaliza.fromJson(Map<String, dynamic> json) {
    return Hortaliza(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      nombreCientifico: json['nombre_cientifico'] as String?,
      tempMinC: (json['temp_min_c'] as num).toDouble(),
      tempMaxC: (json['temp_max_c'] as num).toDouble(),
      tempIdealC: (json['temp_ideal_c'] as num).toDouble(),
      humedadSueloMinPct: (json['humedad_suelo_min_pct'] as num).toDouble(),
      humedadSueloMaxPct: (json['humedad_suelo_max_pct'] as num).toDouble(),
      requerimientoAguaSemanalMm:
          (json['requerimiento_agua_semanal_mm'] as num).toDouble(),
      radiacionSolarMinWm2: (json['radiacion_solar_min_wm2'] as num?)?.toDouble(),
      radiacionSolarMaxWm2: (json['radiacion_solar_max_wm2'] as num?)?.toDouble(),
      altitudMinMsnm: (json['altitud_min_msnm'] as num?)?.toDouble(),
      altitudMaxMsnm: (json['altitud_max_msnm'] as num?)?.toDouble(),
      sensibilidadHeladas: json['sensibilidad_heladas'] as String?,
      sensibilidadHumedadExcesiva:
          json['sensibilidad_humedad_excesiva'] as String?,
      sensibilidadViento: json['sensibilidad_viento'] as String?,
      duracionTotalDias: json['duracion_total_dias'] as int,
      notasGenerales: json['notas_generales'] as String?,
      etapas: (json['etapas'] as List<dynamic>?)
              ?.map((e) => EtapaHortaliza.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'nombre_cientifico': nombreCientifico,
        'temp_min_c': tempMinC,
        'temp_max_c': tempMaxC,
        'temp_ideal_c': tempIdealC,
        'humedad_suelo_min_pct': humedadSueloMinPct,
        'humedad_suelo_max_pct': humedadSueloMaxPct,
        'requerimiento_agua_semanal_mm': requerimientoAguaSemanalMm,
        'radiacion_solar_min_wm2': radiacionSolarMinWm2,
        'radiacion_solar_max_wm2': radiacionSolarMaxWm2,
        'altitud_min_msnm': altitudMinMsnm,
        'altitud_max_msnm': altitudMaxMsnm,
        'sensibilidad_heladas': sensibilidadHeladas,
        'sensibilidad_humedad_excesiva': sensibilidadHumedadExcesiva,
        'sensibilidad_viento': sensibilidadViento,
        'duracion_total_dias': duracionTotalDias,
        'notas_generales': notasGenerales,
        'etapas': etapas.map((e) => e.toJson()).toList(),
      };
}
