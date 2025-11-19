import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/models/usuario_model/usuario_model.dart';
import 'package:uni_share/services/database/database_usuarios/database_usuarios.dart';
import 'package:uni_share/utils/utils/utils.dart';

class DatosUsuario extends StatefulWidget {
  static const String titlePage = 'Datos de usuario';
  static const String route = '/datos_usuario_page';
  static const IconData icon = Icons.person;

  const DatosUsuario({super.key});

  @override
  DatosUsuarioState createState() => DatosUsuarioState();
}

class DatosUsuarioState extends State<DatosUsuario> {
  final TextEditingController mailController = TextEditingController();
  final TextEditingController ciController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();

  final lc = Get.find<LoginController>();
  final loadingC = Get.find<LoadingController>();
  
  UsuarioModel? usuario;
  bool datosCargados = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosUsuario();
    });
  }

  _cargarDatosUsuario() async {
    try {
      loadingC.setOnLoading();
      usuario = await DatabaseUsuarios().readDatosUsuario();
      if (usuario != null) {
        _cargarControladores();
        setState(() {
          datosCargados = true;
        });
      }
    } catch (e) {
      log("Error cargando datos usuario: $e");
      Utils.showSnakbarError(
        "Error",
        "No se pudieron cargar los datos del usuario",
        4,
      );
    } finally {
      loadingC.setOffLoading();
    }
  }

  _cargarControladores() {
    if (usuario != null) {
      mailController.text = usuario!.email;
      ciController.text = usuario!.ci.toString();
      telController.text = usuario!.celular.toString();
      nombresController.text = usuario!.nombres;
      apellidosController.text = usuario!.apellidos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      child: Obx(
        () => LoadingOverlay(
          child: _body(context),
          progressIndicator: Utils.loadingCustom(),
          color: Colors.white.withValues(alpha: 0.6),
          isLoading: loadingC.getLoading,
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Utils.espacio10,
          if (mailController.text.isNotEmpty) ...[
            _inputText('Correo electrónico', mailController, false),
            Utils.espacio10,
          ],
          if (ciController.text.isNotEmpty) ...[
            _inputText('Nro. Cédula identidad', ciController, true),
            Utils.espacio10,
          ],
          if (telController.text.isNotEmpty) ...[
            _inputTextTelefono('Teléfono/Celular'),
            Utils.espacio10,
          ],
          if (nombresController.text.isNotEmpty) ...[
            _inputText('Nombres', nombresController, true),
            Utils.espacio10,
          ],
          if (apellidosController.text.isNotEmpty) ...[
            _inputText('Apellidos', apellidosController, true),
            Utils.espacio10,
          ],
          if (telController.text.isNotEmpty) ...[
            _inputText('Telefono', telController, true),
            Utils.espacio10,
          ],
          Utils.espacio10,
        ],
      ),
    );
  }

  Widget _inputText(
      String title, TextEditingController controller, bool readOnly) {
    return TextField(
      enabled: true,
      readOnly: readOnly,
      controller: controller,
      style: TextStyle(
          fontSize: 16.0,
          color: Get.isDarkMode
              ? Colors.white.withValues(alpha: 0.7)
              : Colors.black.withValues(alpha: 0.8)),
      decoration: InputDecoration(
        labelText: '$title: ',
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelStyle: TextStyle(fontSize: 18.0, color: Utils.primaryColor),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
      ),
    );
  }

  Widget _inputTextTelefono(String title) {
    return TextField(
      enabled: true,
      readOnly: false,
      keyboardType: TextInputType.number,
      controller: telController,
      style: TextStyle(
          fontSize: 16.0,
          color: Get.isDarkMode
              ? Colors.white.withValues(alpha: 0.7)
              : Colors.black.withValues(alpha: 0.8)),
      decoration: InputDecoration(
        labelText: '$title: ',
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        labelStyle: TextStyle(fontSize: 18.0, color: Utils.primaryColor),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mailController.dispose();
    ciController.dispose();
    telController.dispose();
    nombresController.dispose();
    apellidosController.dispose();
    super.dispose();
  }
}