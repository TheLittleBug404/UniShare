import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
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
  final TextEditingController extController = TextEditingController();
  final TextEditingController complController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final lc = Get.find<LoginController>();
  final loadingC = Get.find<LoadingController>();
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    mailController.text = "ricardo@gmail.com";
    ciController.text = "8346117";
    extController.text = "Lp";
    complController.text = "Complemento";
    telController.text = "75284356";
    return Column(
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
        if (extController.text.isNotEmpty) ...[
          _inputText('Extensión', extController, true),
          Utils.espacio10,
        ],
        if (complController.text.isNotEmpty) ...[
          _inputText('Nro. de complemento', complController, true),
          Utils.espacio10,
        ],
      ],
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
}
