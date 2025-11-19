class MaterialModel {
  final int idMaterial;
  final DateTime createdAt;
  final String tipo;
  final String descripcion;
  final String enlaceDoc;
  final String uidUsuario;
  final int materia;

  MaterialModel ({
    required this.idMaterial,
    required this.createdAt,
    required this.tipo,
    required this.descripcion,
    required this.enlaceDoc,
    required this.uidUsuario,
    required this.materia
  });

  factory MaterialModel .fromMap(Map<String, dynamic> map) {
    return MaterialModel (
      idMaterial: map['id_material'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      tipo: map['tipo'] as String,
      descripcion: map['descripcion'] as String,
      enlaceDoc: map['enlace_doc'] as String,
      uidUsuario: map['uid_usuario'] as String,
      materia: map['materia'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_material': idMaterial,
      'created_at': createdAt.toIso8601String(),
      'tipo': tipo,
      'descripcion': descripcion,
      'enlace_doc': enlaceDoc,
      'uid_usuario': uidUsuario,
      'materia' : materia,
    };
  }

  // Para debugging
  @override
  String toString() {
    return 'Material(idMaterial: $idMaterial, tipo: $tipo, descripcion: $descripcion, enlaceDoc: $enlaceDoc, uidUsuario: $uidUsuario, createdAt: $createdAt, materia $materia)';
  }

  // Para comparación de objetos
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialModel  && other.idMaterial == idMaterial;
  }

  @override
  int get hashCode => idMaterial.hashCode;
}