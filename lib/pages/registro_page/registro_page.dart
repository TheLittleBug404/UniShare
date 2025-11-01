import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uni_share/pages/registro_valido_page/registro_valido_page.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showDialog();
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
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Utils.espacio10,
                    SizedBox(
                      height: Get.height * 0.25,
                      width: Get.width * 0.35,
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
                    _botonValidar(context),
                    Utils.espacio20,
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: Utils.elevatedButton(
                        "CANCELAR",
                        Utils.primaryColor,
                        () {
                          Navigator.pop(context);
                        },
                        14.0,
                      ),
                    ),
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

  _botonValidar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: Utils.elevatedButton("VALIDAR", Utils.colorTextoBordesIconos, () {
        _formKey.currentState!.save();
        if (!_formKey.currentState!.validate()) {
          Utils.showSnakbarError("Error", 'Existen campos inválidos', 2);
          //setState(() => _loading = false);
        } else if (_passwordController.text != _passwordController2.text) {
          Utils.showSnakbarError("Error", 'Las contraseñas no son iguales', 2);
        } else {
          Get.to(
            RegistroValidoPage(
              emailRegistro: _emailController.text,
              passwordRegistro: _passwordController.text,
            ),
          );
        }
      }, 14.0),
    );
  }
}
