import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageServices {
  final SupabaseClient supabase = Supabase.instance.client;

  /*Future<String> uploadFile() async {
    String resultado = "";
    var pickedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (pickedFile != null) {
      try {
        String fileName = pickedFile.files.first.name;
        String pathName = "${supabase.auth.currentUser!.id}/$fileName";
        resultado = pathName;
      } catch (e) {
        log("ERRORRRRR :::::> $e");
      }
    }
    return resultado;
  }*/
  // Método para seleccionar archivo (solo obtiene el File, no sube)
  Future<PlatformFile?> seleccionarArchivo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first;
      }
      return null;
    } catch (e) {
      log("Error al seleccionar archivo: $e");
      return null;
    }
  }

  // Método para subir archivo a Supabase
  Future<String> subirArchivo(PlatformFile archivo) async {
    try {
      // Generar nombre único para el archivo
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${archivo.name}";
      String pathName = "${supabase.auth.currentUser!.id}/$fileName";

      // Subir el archivo a Supabase
      final response = await supabase.storage
          .from('docUniShare') // Ajusta el nombre de tu bucket
          .upload(
            pathName,
            File(archivo.path!), // Convertir a File
            fileOptions: FileOptions(upsert: true),
          );
      log(response);
      // Obtener la URL pública del archivo
      final publicUrl = supabase.storage
          .from('docUniShare')
          .getPublicUrl(pathName);

      return publicUrl;
    } catch (e) {
      log("Error al subir archivo a Supabase: $e");
      rethrow;
    }
  }

  // Método para subir cuando es tipo "Enlace" (solo guarda el enlace)
  Future<String> subirEnlace(String enlace) async {
    // Para enlaces, simplemente retornamos el enlace proporcionado
    return enlace;
  }
}
