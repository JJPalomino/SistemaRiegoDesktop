/// Modelos de siembras (ciclos de cultivo dentro de una parcela).
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
class Siembra {
  const Siembra({
    required this.id,
    required this.parcelaId,
    required this.hortalizaId,
    required this.fechaSiembra,
    required this.activa,
    this.fechaCosecha,
    this.notas,
    this.nombreHortaliza,
    this.diasDesdeSiembra = 0,
    this.createdAt,
  });

  final int id;
  final int parcelaId;
  final int hortalizaId;
  final String fechaSiembra;
  final String? fechaCosecha;
  final bool activa;
  final String? notas;
  final String? nombreHortaliza;
  final int diasDesdeSiembra;
  final DateTime? createdAt;

  factory Siembra.fromJson(Map<String, dynamic> json) {
    return Siembra(
      id: json['id'] as int,
      parcelaId: json['parcela_id'] as int,
      hortalizaId: json['hortaliza_id'] as int,
      fechaSiembra: json['fecha_siembra'] as String,
      fechaCosecha: json['fecha_cosecha'] as String?,
      activa: json['activa'] as bool? ?? true,
      notas: json['notas'] as String?,
      nombreHortaliza: json['nombre_hortaliza'] as String?,
      diasDesdeSiembra: json['dias_desde_siembra'] as int? ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parcela_id': parcelaId,
        'hortaliza_id': hortalizaId,
        'fecha_siembra': fechaSiembra,
        'fecha_cosecha': fechaCosecha,
        'activa': activa,
        'notas': notas,
        'nombre_hortaliza': nombreHortaliza,
        'dias_desde_siembra': diasDesdeSiembra,
        'created_at': createdAt?.toIso8601String(),
      };
}

class SiembraCreate {
  const SiembraCreate({
    required this.hortalizaId,
    required this.fechaSiembra,
    this.fechaCosecha,
    this.activa = true,
    this.notas,
  });

  final int hortalizaId;
  final String fechaSiembra;
  final String? fechaCosecha;
  final bool activa;
  final String? notas;

  factory SiembraCreate.fromJson(Map<String, dynamic> json) => SiembraCreate(
        hortalizaId: json['hortaliza_id'] as int,
        fechaSiembra: json['fecha_siembra'] as String,
        fechaCosecha: json['fecha_cosecha'] as String?,
        activa: json['activa'] as bool? ?? true,
        notas: json['notas'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hortaliza_id': hortalizaId,
        'fecha_siembra': fechaSiembra,
        'fecha_cosecha': fechaCosecha,
        'activa': activa,
        'notas': notas,
      };
}
