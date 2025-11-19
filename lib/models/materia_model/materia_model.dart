class MateriaModel{
  final int idMateria;
  final String semestre;
  final String nombre;
  final String sigla;

  MateriaModel({
    required this.idMateria,
    required this.semestre,
    required this.nombre,
    required this.sigla
  });

  factory MateriaModel.fromMap(Map<String,dynamic> map){
    return MateriaModel(
      idMateria: map['id_materia'] as int, 
      semestre: map['semestre'] as String, 
      nombre: map['nombre'] as String, 
      sigla: map['sigla'] as String,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id_materia' : idMateria,
      'semestre' : semestre,
      'nombre' : nombre,
      'sigla' : sigla,
    };
  }

  // Para debugging
  @override
  String toString() {
    return 'Materia(idMateria: $idMateria, semestre: $semestre, nombre: $nombre, sigla: $sigla)';
  }
}