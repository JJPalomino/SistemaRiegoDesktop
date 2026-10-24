/// Modelos del historial de recomendaciones.
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
class ConsultaRecomendacionResumen {
  const ConsultaRecomendacionResumen({
    required this.id,
    required this.nombreHortaliza,
    required this.diasSiembra,
    required this.recomendacionRiego,
    required this.recomendacionGeneral,
    this.parcelaId,
    this.siembraId,
    this.lecturaClimaticaId,
    this.hortalizaId,
    this.etapa,
    this.nivelUrgenciaMax = 'informativa',
    this.modeloLlm,
    this.demoMode = false,
    this.consultadoEn,
  });

  final int id;
  final int? parcelaId;
  final int? siembraId;
  final int? lecturaClimaticaId;
  final int? hortalizaId;
  final String nombreHortaliza;
  final String? etapa;
  final int diasSiembra;
  final String recomendacionRiego;
  final String recomendacionGeneral;
  final String nivelUrgenciaMax;
  final String? modeloLlm;
  final bool demoMode;
  final DateTime? consultadoEn;

  factory ConsultaRecomendacionResumen.fromJson(Map<String, dynamic> json) {
    return ConsultaRecomendacionResumen(
      id: json['id'] as int,
      parcelaId: json['parcela_id'] as int?,
      siembraId: json['siembra_id'] as int?,
      lecturaClimaticaId: json['lectura_climatica_id'] as int?,
      hortalizaId: json['hortaliza_id'] as int?,
      nombreHortaliza: json['nombre_hortaliza'] as String? ?? 'Hortaliza',
      etapa: json['etapa'] as String?,
      diasSiembra: json['dias_siembra'] as int? ?? 0,
      recomendacionRiego: json['recomendacion_riego'] as String? ?? '',
      recomendacionGeneral: json['recomendacion_general'] as String? ?? '',
      nivelUrgenciaMax: json['nivel_urgencia_max'] as String? ?? 'informativa',
      modeloLlm: json['modelo_llm'] as String?,
      demoMode: json['demo_mode'] as bool? ?? false,
      consultadoEn: json['consultado_en'] == null
          ? null
          : DateTime.parse(json['consultado_en'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcela_id': parcelaId,
        'siembra_id': siembraId,
        'lectura_climatica_id': lecturaClimaticaId,
        'hortaliza_id': hortalizaId,
        'nombre_hortaliza': nombreHortaliza,
        'etapa': etapa,
        'dias_siembra': diasSiembra,
        'recomendacion_riego': recomendacionRiego,
        'recomendacion_general': recomendacionGeneral,
        'nivel_urgencia_max': nivelUrgenciaMax,
        'modelo_llm': modeloLlm,
        'demo_mode': demoMode,
        'consultado_en': consultadoEn?.toIso8601String(),
      };
}

class ConsultaRecomendacionDetalle {
  const ConsultaRecomendacionDetalle({
    required this.id,
    required this.nombreHortaliza,
    required this.diasSiembra,
    required this.recomendacionRiego,
    required this.recomendacionGeneral,
    required this.prompt,
    required this.respuestaJson,
    this.parcelaId,
    this.siembraId,
    this.lecturaClimaticaId,
    this.hortalizaId,
    this.etapa,
    this.nivelUrgenciaMax = 'informativa',
    this.modeloLlm,
    this.demoMode = false,
    this.consultadoEn,
  });

  final int id;
  final int? parcelaId;
  final int? siembraId;
  final int? lecturaClimaticaId;
  final int? hortalizaId;
  final String nombreHortaliza;
  final String? etapa;
  final int diasSiembra;
  final String recomendacionRiego;
  final String recomendacionGeneral;
  final String nivelUrgenciaMax;
  final String? modeloLlm;
  final bool demoMode;
  final DateTime? consultadoEn;
  final String prompt;
  final Map<String, dynamic> respuestaJson;

  factory ConsultaRecomendacionDetalle.fromJson(Map<String, dynamic> json) {
    return ConsultaRecomendacionDetalle(
      id: json['id'] as int,
      parcelaId: json['parcela_id'] as int?,
      siembraId: json['siembra_id'] as int?,
      lecturaClimaticaId: json['lectura_climatica_id'] as int?,
      hortalizaId: json['hortaliza_id'] as int?,
      nombreHortaliza: json['nombre_hortaliza'] as String? ?? 'Hortaliza',
      etapa: json['etapa'] as String?,
      diasSiembra: json['dias_siembra'] as int? ?? 0,
      recomendacionRiego: json['recomendacion_riego'] as String? ?? '',
      recomendacionGeneral: json['recomendacion_general'] as String? ?? '',
      nivelUrgenciaMax: json['nivel_urgencia_max'] as String? ?? 'informativa',
      modeloLlm: json['modelo_llm'] as String?,
      demoMode: json['demo_mode'] as bool? ?? false,
      consultadoEn: json['consultado_en'] == null
          ? null
          : DateTime.parse(json['consultado_en'] as String),
      prompt: json['prompt'] as String? ?? '',
      respuestaJson: (json['respuesta_json'] as Map?)?.cast<String, dynamic>() ??
          const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcela_id': parcelaId,
        'siembra_id': siembraId,
        'lectura_climatica_id': lecturaClimaticaId,
        'hortaliza_id': hortalizaId,
        'nombre_hortaliza': nombreHortaliza,
        'etapa': etapa,
        'dias_siembra': diasSiembra,
        'recomendacion_riego': recomendacionRiego,
        'recomendacion_general': recomendacionGeneral,
        'nivel_urgencia_max': nivelUrgenciaMax,
        'modelo_llm': modeloLlm,
        'demo_mode': demoMode,
        'consultado_en': consultadoEn?.toIso8601String(),
        'prompt': prompt,
        'respuesta_json': respuestaJson,
      };
}
