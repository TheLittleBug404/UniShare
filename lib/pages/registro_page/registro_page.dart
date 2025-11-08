import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/services/metodos_supabase/metodos_supabase.dart';
import 'package:uni_share/utils/helpers/helpers.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:get/get.dart';

class RegistroPage extends StatefulWidget {
  static const String titlePage = 'Datos de la cuenta';
  static const String route = '/registrarse_page';
  static const IconData icon = Icons.person_add;
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  bool passwordVisible = true;
  bool passwordVisible2 = true;
  String email = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  final loadingC = Get.find<LoadingController>();
  final metodosSupabase = MetodosSupabase();

  @override
  void initState() {
    super.initState();
    _showDialog();
    metodosSupabase.getSession(supabase);
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    Utils.showAwesomeDialog(
      "¡Importante!",
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Utils.estiloTexto(
          "Si ya se registró desde Google, puede utilizar esa cuenta para ingresar en la aplicacion, no es necesario volver a registrarse desde esta pantalla.",
          16.0,
          false,
          Colors.black,
          true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Utils.espacio10,
                    SizedBox(
                      height: Get.height * 0.25,
                      width: Get.width * 0.55,
                      child: Utils.uniShareLogo(),
                    ),
                    Utils.espacio10,
                    Center(
                      child: Utils.estiloTexto(
                        RegistroPage.titlePage,
                        20.0,
                        true,
                      ),
                    ),
                    Utils.espacio20,
                    inputTextCorreo(),
                    Utils.espacio20,
                    inputTextPassword(),
                    Utils.espacio10,
                    inputTextPasswordConfirm(),
                    Utils.espacio20,
                    const Text(
                      'La contraseña debe tener de 6 a 12 caracteres y debe contener al menos una letra mayúscula y un número. ',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    Utils.espacio20,
                    _botonRegistrar(context),
                    Utils.espacio20,
                    _botonCancelar(context),
                    Utils.espacio60,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputTextCorreo() {
    return FormBuilderTextField(
      name: "email",
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin(Helpers.correoText, true),
      onChanged: null,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.email(errorText: Helpers.errorCorreoFormato),
        FormBuilderValidators.maxLength(100),
      ]),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget inputTextPassword() {
    final originalDecoration = Utils.estiloInputTextFiledLogin(
      Helpers.contraseniaText,
      true,
    );
    final newDecoration = originalDecoration.copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: Utils.colorAzul(
            0.8,
          ), //color: Color(0xE400581C), // Color verde
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
      name: "password",
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: passwordVisible,
      style: Utils.estiloLetraInput(),
      decoration: newDecoration,
      onChanged: null,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.maxLength(12, errorText: Helpers.longitudMaxima),
        (val) {
          if (Utils.isPasswordCompliant(val!)) {
            return null;
          } else {
            return Helpers.errorPassword;
          }
        },
      ]),
      keyboardType: TextInputType.text,
    );
  }

  Widget inputTextPasswordConfirm() {
    final originalDecoration = Utils.estiloInputTextFiledLogin(
      Helpers.contraseniaTextConfirm,
      true,
    );
    final newDecoration = originalDecoration.copyWith(
      suffixIcon: IconButton(
        icon: Icon(
          passwordVisible2 ? Icons.visibility_off : Icons.visibility,
          color: Utils.colorAzul(
            0.8,
          ), //color: Color(0xE400581C), // Color verde
        ),
        onPressed: () {
          setState(() {
            passwordVisible2 = !passwordVisible2;
          });
        },
      ),
      alignLabelWithHint: false,
      filled: true,
    );

    return FormBuilderTextField(
      name: "password2",
      controller: _passwordController2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: passwordVisible2,
      style: Utils.estiloLetraInput(),
      decoration: newDecoration,
      // onChanged: FormBuilderValidators.equal(_passwordController.text,       errorText: Helpers.errorContraseniaNoCoincide),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        //FormBuilderValidators.equal(_passwordController.text,            errorText: Helpers.errorContraseniaNoCoincide),
      ]),
      keyboardType: TextInputType.text,
    );
  }

  _botonRegistrar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: Utils.elevatedButton(
        "REGISTRAR",
        Utils.colorTextoBordesIconos,
        () async {
          Utils.ocultarTeclado(context);
          loadingC.setOnLoading();
          log("Loading presionado ${loadingC.getLoading}");
          _formKey.currentState!.save();
          try {
            if (!_formKey.currentState!.validate()) {
              Utils.showSnakbarError("Error", 'Existen campos inválidos', 4);
              return;
            }
            if (_passwordController.text != _passwordController2.text) {
              Utils.showSnakbarError(
                "Error",
                'Las contraseñas no son iguales',
                4,
              );
              return;
            }
            await supabase.auth.signUp(
              emailRedirectTo: kIsWeb ? null : 'io.supabase.unishare://login-callback',
              email: _emailController.text.toString(),
              password: _passwordController.text.toString(),
            );
            Get.to(HomePage(), duration: Duration(milliseconds: 500));
            Utils.showSnakbarOK("Exito", "Cuenta creada revise su correo", 4);
          } catch (e) {
            Utils.showSnakbarError(
              "Error",
              "!Error al intentar crear cuenta en UniShare!",
              4,
            );
          } finally{
            loadingC.setOffLoading();
          }
        },
        14.0,
      ),
    );
  }

  _botonCancelar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: Utils.elevatedButton(
        "CANCELAR", 
        Utils.primaryColor, 
        () {
          log("presionaste el boton cancelar ::::> ${loadingC.getLoading}");
          Navigator.pop(context);
        }, 
        14.0,
      ),
    );
  }
}
