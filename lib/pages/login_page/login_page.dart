import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/pages/registro_page/registro_page.dart';
import 'package:uni_share/utils/helpers/helpers.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  static const String titlePage = 'Login';
  static const String route = '/login_page';
  static const IconData icon = Icons.person;
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  String emailRestorePass = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final loadingC = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(
          () => LoadingOverlay(
            progressIndicator: Utils.loadingCustom(),
            color: Colors.white.withValues(alpha: 0.6),
            isLoading: loadingC.getLoading,
            child: _body(context),
          ),
        ),
      ),
    );
  }

  Stack _body(BuildContext context) {
    return Stack(
      children: <Widget>[
        Utils.fondo(),
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, //end
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SafeArea(child: Container(height: 30.0)),
                Utils.uniShareLogo(),
                Utils.espacio10,
                _buttonGoogle(),
                Utils.espacio10,
                _inputTextCorreo('Correo electrónico'),
                Utils.espacio10,
                _inputTextPassword('Contraseña'),
                Utils.espacio20,
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: _botonIngresar(),
                ),
                Utils.espacio10,
                /*TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () async {
                    await _showRecuperarContrasenia(
                      context,
                      'Recuperar contraseña',
                      Utils.colorTextoBordesIconos, //Utils.colorGuindo(0.8),
                      'Ingrese su correo electrónico con el que se registro en el sistema.',
                      emailRestorePass,
                    );
                  },
                  child: Utils.estiloTexto(
                    '¿Olvidó su contraseña?',
                    14.0,
                    false,
                    Utils.colorTextoBordesIconos,
                  ),
                ),*/
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: Utils.elevatedButton(
                    "REGISTRARSE",
                    Utils.primaryColor,
                    () {
                      Get.to(
                        RegistroPage(),
                        duration: Duration(milliseconds: 500),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buttonGoogle() {
    return SignInButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      Buttons.google,
      text: "INGRESAR CON GOOGLE",
      onPressed: () async {
        //await LoginServiceGoogle().loginGoogle();
        log('Presionaste el boton ingresar con google');
      },
    );
  }

  _botonIngresar() {
    final lc = Get.find<LoginController>();
    return Utils.elevatedButton(
      Helpers.ingresar.toUpperCase(),
      Utils.colorTextoBordesIconos,
      () async {
        log('Presionaste el boton ingresar');
      },
      14.0,
    );
  }

  _inputTextCorreo(String s) {
    return FormBuilderTextField(
      name: s,
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin(Helpers.correoText, true),
      onChanged: null,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.email(errorText: Helpers.errorCorreoFormato),
        FormBuilderValidators.maxLength(70),
      ]),
      keyboardType: TextInputType.emailAddress,
    );
  }

  _inputTextPassword(String s) {
    final originalDecoration = Utils.estiloInputTextFiledLogin(
      Helpers.contraseniaText,
      true,
    );
    final newDecoration = originalDecoration.copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: Utils.colorAzul(0.8), //color: Color(0xE400581C)
        ),
        onPressed: () {
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
      ),
      alignLabelWithHint: false,
      filled: true,
    );

    return FormBuilderTextField(
      name: s,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: passwordVisible,
      style: Utils.estiloLetraInput(),
      decoration: newDecoration,
      onChanged: null,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
      ]),
      keyboardType: TextInputType.text,
    );
  }
}
