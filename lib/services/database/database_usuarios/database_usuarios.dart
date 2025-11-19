//clase de nuestra base de datos
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/models/usuario_model/usuario_model.dart';

class DatabaseUsuarios {
  //*conexion
  SupabaseClient supabase = Supabase.instance.client;
  //*create
  crearUsuario(
    String email,
    String ci,
    String nombres,
    String apellidos,
    String telefono,
    String userId
  ) async {
    try {
      final ciNum = num.tryParse(ci);
      final telefonoNum = num.tryParse(telefono);
      await supabase.from('usuarios').insert({
        'email': email,
        'ci': ciNum,
        'nombres': nombres,
        'apellidos': apellidos,
        'celular': telefonoNum,
        'uid_usuario': userId,
      });
    } catch (e) {
      log("Mostrando error en data $e");
    }
  }

  //*read 
  readCorreo(String correo)async{
    final respuesta  = await supabase.from('usuarios').select().eq('email', correo);
    if(respuesta.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Future<UsuarioModel?> readDatosUsuario() async{
    var userId = supabase.auth.currentUser!.id;
    final data = await supabase.from('usuarios').select().eq('uid_usuario', userId);
    if(data.isNotEmpty){
      return UsuarioModel.fromJson(data[0]);
    }else{
      return null;
    }
  }

  Future<UsuarioModel?> readNombreUsuario() async{
    var userId = supabase.auth.currentUser!.id;
    final data  = await supabase.from('usuarios').select().eq('uid_usuario', userId);
    return UsuarioModel.fromJson(data[0]);
  }
  //*update
  //*delete
}
