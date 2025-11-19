class PerteneceModel {
  final int idMaterial;
  final int idMateria;

  PerteneceModel({
    required this.idMaterial, 
    required this.idMateria
  });

  factory PerteneceModel.fromMap(Map<String,dynamic> map){
    return PerteneceModel(
      idMaterial: map['id_material'] as int,
      idMateria: map['id_materia'] as int,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id_material' : idMaterial,
      'id_materia'  : idMateria,
    };
  }

  // Para debugging
  @override
  String toString() {
    return 'Pertenece(idMaterial: $idMaterial, idMateria: $idMateria)';
  }
}