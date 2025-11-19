class UsuarioModel {
  final int id;
  final DateTime createdAt;
  final String email;
  final int ci;
  final String nombres;
  final String apellidos;
  final int celular;
  final String uidUsuario;

  UsuarioModel({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.ci,
    required this.nombres,
    required this.apellidos,
    required this.celular,
    required this.uidUsuario,
  });

  // Factory constructor para crear instancia desde JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] as String,
      ci: json['ci'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      celular: json['celular'] as int,
      uidUsuario: json['uid_usuario'] as String,
    );
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'ci': ci,
      'nombres': nombres,
      'apellidos': apellidos,
      'celular': celular,
      'uid_usuario': uidUsuario,
    };
  }

  // Método para crear copia con cambios
  UsuarioModel copyWith({
    int? id,
    DateTime? createdAt,
    String? email,
    int? ci,
    String? nombres,
    String? apellidos,
    int? celular,
    String? uidUsuario,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      ci: ci ?? this.ci,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      celular: celular ?? this.celular,
      uidUsuario: uidUsuario ?? this.uidUsuario,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nombres: $nombres, apellidos: $apellidos, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsuarioModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}