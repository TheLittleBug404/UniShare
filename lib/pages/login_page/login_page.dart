import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/pages/principal_page/principal_page.dart';
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
  final SupabaseClient supabase = Supabase.instance.client;

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
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: _botonRegistro(),
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
        final lc = Get.find<LoginController>();
        log('Presionaste el boton ingresar con google');
        loadingC.setOnLoading();
        bool internet = await Utils.hasInternet();
        const webClientId =
            '959671764801-flrr1st5mqcend2ugevies5o6f790bsr.apps.googleusercontent.com';
        const iosClientId =
            '959671764801-mejnufcglfddgpqfi5rvmnnmmp9v9204.apps.googleusercontent.com';
        try {
          if (!internet) {
            Utils.showSnakbarSinInternet(
              "Sin conexión a internet",
              "Revise su conexión a internet",
              4,
            );
            return;
          }
          final GoogleSignIn signIn = GoogleSignIn.instance;
          unawaited(
            signIn.initialize(
              clientId: iosClientId,
              serverClientId: webClientId,
            ),
          );
          final googleAccount = await signIn.authenticate();
          final googleAuthorization = await googleAccount.authorizationClient
              .authorizationForScopes(['Correo electrónico']);
          final googleAuthentication = googleAccount.authentication;
          final idToken = googleAuthentication.idToken;
          final accessToken = googleAuthorization?.accessToken;

          if (idToken == null) {
            throw 'No ID Token found.';
          }
          await supabase.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
          lc.setAuth(true);
          Get.to(PrincipalPage(), duration: Duration(milliseconds: 500));
          Utils.showSnakbarOK("Bienvenido", "Sesión iniciada con Google", 4);
        } catch (e) {
          Utils.showSnakbarError(
            "Error",
            "No se pudo iniciar sesión con Google",
            4,
          );
        } finally {
          loadingC.setOffLoading();
        }
      },
    );
  }

  _botonIngresar() {
    final lc = Get.find<LoginController>();
    return Utils.elevatedButton(
      Helpers.ingresar.toUpperCase(),
      Utils.colorTextoBordesIconos,
      () async {
        Utils.ocultarTeclado(context);
        loadingC.setOnLoading();
        bool internet = await Utils.hasInternet();
        _formKey.currentState!.save();
        try {
          if (!internet) {
            Utils.showSnakbarSinInternet(
              "Sin conexión a internet",
              "Revise su conexión a internet",
              4,
            );
            return;
          }
          if (!_formKey.currentState!.validate()) {
            Utils.showSnakbarError("Error", 'Existen campos inválidos', 4);
            return;
          }
          await supabase.auth.signInWithPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString(),
          );
          lc.setAuth(true);
          Get.to(PrincipalPage(), duration: Duration(milliseconds: 500));
          Utils.showSnakbarOK("Bienvenido", "Sesion Iniciada con exito", 4);
        } catch (e) {
          Utils.showSnakbarError(
            "Error al iniciar sesión",
            "!Datos erroneos verifique correo o contraseña!",
            4,
          );
        } finally {
          loadingC.setOffLoading();
        }
      },
      14.0,
    );
  }

  _botonRegistro() {
    return Utils.elevatedButton("REGISTRATE", Utils.primaryColor, () async {
      bool internet = await Utils.hasInternet();
      if (!internet) {
        Utils.showSnakbarSinInternet(
          "Sin conexión a internet",
          "Revise su conexión a internet",
          4,
        );
        return;
      }
      log("presionaste el boton REGISTRAR ::::>");
      Get.to(RegistroPage(), duration: Duration(milliseconds: 500));
    });
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
          color: Utils.colorAzul(0.8),
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
