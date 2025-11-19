import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/models/material_model/material_model.dart';

class DatabaseMaterial {
  //*conexion
  SupabaseClient supabase = Supabase.instance.client;
  //*create
  /*crearMaterial(String tipo,String descripcion,String enlaceDoc) async{
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('material').insert({
      'tipo' : tipo,
      'desccripcion' : descripcion,
      'enlace_doc' : enlaceDoc,
      'uid_usuario' : userId,
    });
  }*/
  // Debe retornar el ID del material creado
  Future<int> crearMaterial(
    String tipo,
    String descripcion,
    String enlace,
    int materia,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('material')
          .insert({
            'tipo': tipo,
            'descripcion': descripcion,
            'enlace_doc': enlace,
            'uid_usuario': userId,
            'materia' : materia
          })
          .select('id_material') // Esto retorna el ID generado
          .single();

      return response['id_material'] as int;
    } catch (e) {
      log("Error al crear material: $e");
      rethrow;
    }
  }

  //*read
  //readMaterial() {}

  Future<List<MaterialModel>> readMaterial() async {
    final respuesta = await supabase.from('material').select();
    // Convertir cada Map a tu modelo MaterialModel
    return respuesta.map((map) => MaterialModel.fromMap(map)).toList();
  }
  //*update
  //*delete
}
