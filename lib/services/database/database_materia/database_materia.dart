import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/models/materia_model/materia_model.dart';

class DatabaseMateria {
  //*conexion
  SupabaseClient supabase = Supabase.instance.client;
  //*create
  /*crearMateria(String semestre, String nombre,String sigla) async{
    await supabase.from('materia').insert({
      'semestre' : semestre,
      'nombre': nombre,
      'sigla' : sigla,
    });
  }*/
  // Debe retornar el ID de la materia creada
  Future<int> crearMateria(String semestre, String nombre, String sigla) async {
    try {
      final response = await supabase
          .from('materia')
          .insert({'semestre': semestre, 'nombre': nombre, 'sigla': sigla})
          .select('id_materia') // Esto retorna el ID generado
          .single();

      return response['id_materia'] as int;
    } catch (e) {
      log("Error al crear materia: $e");
      rethrow;
    }
  }

  //*read

  Future<List<MateriaModel>> readMateria() async {
    final respuesta = await supabase.from('materia').select();
    // Convertir cada Map a tu modelo MaterialModel
    return respuesta.map((map) => MateriaModel.fromMap(map)).toList();
  }

  //*update
  //*delete
}
