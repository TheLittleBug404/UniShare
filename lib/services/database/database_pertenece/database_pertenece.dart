import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/models/pertenece_model/pertenece_model.dart';

class DatabasePertenece {
  //*conexion
  SupabaseClient supabase = Supabase.instance.client;
  //*create
  /*createPertenece(int idMaterial, int idMateria) async{
    await supabase.from('pertenece').insert({
      'id_material' : idMaterial,
      'id_materia' : idMateria,
    });
  }*/
  Future<void> crearRelacionPertenece(int idMaterial, int idMateria) async {
    try {
      await supabase.from('pertenece').insert({
        'id_material': idMaterial,
        'id_materia': idMateria,
      });

      log("Relación creada: Material $idMaterial -> Materia $idMateria");
    } catch (e) {
      log("Error al crear relación pertenece: $e");
      rethrow;
    }
  }

  //*read
  Future<List<PerteneceModel>> readPertenece() async {
    final respuesta = await supabase.from('pertenece').select();
    // Convertir cada Map a tu modelo PerteneceModel
    return respuesta.map((map) => PerteneceModel.fromMap(map)).toList();
  }
  //*update
  //*delete
}
