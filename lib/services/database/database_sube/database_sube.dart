import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseSube {
  //*conexion
  SupabaseClient supabase = Supabase.instance.client;
  //*create
  createSube(int idUsuarios, int idMaterial) async{
    await supabase.from('sube').insert({
      'id_usuario' : idUsuarios,
      'id_material' : idMaterial,
    });
  }
  //*read
  //*update
  //*delete
}