/// Modelos de parcelas (microparcelas del productor).
///
/// Se escriben a mano (sin codegen) para no depender de build_runner.
enum TexturaSuelo {
  arenoso,
  francoArenoso,
  franco,
  francoArcilloso,
  arcilloso;

  /// Valor tal como lo espera el backend (`franco_arenoso`, etc.).
  String get apiValue => switch (this) {
        TexturaSuelo.arenoso => 'arenoso',
        TexturaSuelo.francoArenoso => 'franco_arenoso',
        TexturaSuelo.franco => 'franco',
        TexturaSuelo.francoArcilloso => 'franco_arcilloso',
        TexturaSuelo.arcilloso => 'arcilloso',
      };

  /// Etiqueta que se muestra al usuario (con mayúscula y sin guion bajo).
  String get label => switch (this) {
        TexturaSuelo.arenoso => 'Arenoso',
        TexturaSuelo.francoArenoso => 'Franco arenoso',
        TexturaSuelo.franco => 'Franco',
        TexturaSuelo.francoArcilloso => 'Franco arcilloso',
        TexturaSuelo.arcilloso => 'Arcilloso',
      };

  static TexturaSuelo fromApi(String? value) {
    switch (value) {
      case 'arenoso':
        return TexturaSuelo.arenoso;
      case 'franco_arenoso':
        return TexturaSuelo.francoArenoso;
      case 'franco_arcilloso':
        return TexturaSuelo.francoArcilloso;
      case 'arcilloso':
        return TexturaSuelo.arcilloso;
      case 'franco':
      default:
        return TexturaSuelo.franco;
    }
  }
}

class Parcela {
  const Parcela({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.texturaSuelo,
    required this.activa,
    this.altitudMsnm,
    this.areaM2,
    this.notas,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int usuarioId;
  final String nombre;
  final double latitud;
  final double longitud;
  final double? altitudMsnm;
  final double? areaM2;
  final TexturaSuelo texturaSuelo;
  final bool activa;
  final String? notas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Parcela.fromJson(Map<String, dynamic> json) {
    return Parcela(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int? ?? 0,
      nombre: json['nombre'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      altitudMsnm: (json['altitud_msnm'] as num?)?.toDouble(),
      areaM2: (json['area_m2'] as num?)?.toDouble(),
      texturaSuelo: TexturaSuelo.fromApi(json['textura_suelo'] as String?),
      activa: json['activa'] as bool? ?? true,
      notas: json['notas'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuario_id': usuarioId,
        'nombre': nombre,
        'latitud': latitud,
        'longitud': longitud,
        'altitud_msnm': altitudMsnm,
        'area_m2': areaM2,
        'textura_suelo': texturaSuelo.apiValue,
        'activa': activa,
        'notas': notas,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class ParcelaCreate {
  const ParcelaCreate({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    this.altitudMsnm,
    this.areaM2,
    this.texturaSuelo = TexturaSuelo.franco,
    this.activa = true,
    this.notas,
  });

  final String nombre;
  final double latitud;
  final double longitud;
  final double? altitudMsnm;
  final double? areaM2;
  final TexturaSuelo texturaSuelo;
  final bool activa;
  final String? notas;

  factory ParcelaCreate.fromJson(Map<String, dynamic> json) => ParcelaCreate(
        nombre: json['nombre'] as String,
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
        altitudMsnm: (json['altitud_msnm'] as num?)?.toDouble(),
        areaM2: (json['area_m2'] as num?)?.toDouble(),
        texturaSuelo: TexturaSuelo.fromApi(json['textura_suelo'] as String?),
        activa: json['activa'] as bool? ?? true,
        notas: json['notas'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'latitud': latitud,
        'longitud': longitud,
        'altitud_msnm': altitudMsnm,
        'area_m2': areaM2,
        'textura_suelo': texturaSuelo.apiValue,
        'activa': activa,
        'notas': notas,
      };
}
