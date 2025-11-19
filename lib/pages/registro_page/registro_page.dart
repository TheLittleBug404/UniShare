import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/services/database/database_usuarios/database_usuarios.dart';
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
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

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
        child: Obx(
          () => LoadingOverlay(
            progressIndicator: Utils.loadingCustom(),
            color: Colors.white.withValues(alpha: 0.6),
            isLoading: loadingC.getLoading,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Utils.espacio10,
                        SizedBox(
                          height: Get.height * 0.20,
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
                        _buildPersonalInfoSection(),
                        Utils.espacio20,
                        _buildAccountInfoSection(),
                        Utils.espacio20,
                        _botonRegistrar(context),
                        Utils.espacio10,
                        _botonCancelar(context),
                        Utils.espacio40,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      children: [
        _sectionTitle('Información Personal'),
        Utils.espacio15,
        inputTextCI(),
        Utils.espacio15,
        inputTextNombres(),
        Utils.espacio15,
        inputTextApellidos(),
        Utils.espacio15,
        inputTextTelefono(),
      ],
    );
  }

  Widget _buildAccountInfoSection() {
    return Column(
      children: [
        _sectionTitle('Información de la Cuenta'),
        Utils.espacio15,
        inputTextCorreo(),
        Utils.espacio15,
        inputTextPassword(),
        Utils.espacio10,
        inputTextPasswordConfirm(),
        Utils.espacio10,
        const Text(
          'La contraseña debe tener de 6 a 12 caracteres y debe contener al menos una letra mayúscula y un número.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Utils.colorAzul(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Utils.colorAzul(0.3), width: 1),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Utils.colorAzul(0.8),
        ),
      ),
    );
  }

  Widget inputTextCI() {
    return FormBuilderTextField(
      name: "ci",
      controller: _ciController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin('Cédula de Identidad', true),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.numeric(
          errorText: 'La CI debe contener solo números',
        ),
        FormBuilderValidators.minLength(
          6,
          errorText: 'La CI debe tener al menos 6 dígitos',
        ),
        FormBuilderValidators.maxLength(
          15,
          errorText: 'La CI no puede exceder 15 dígitos',
        ),
      ]),
      keyboardType: TextInputType.number,
    );
  }

  Widget inputTextNombres() {
    return FormBuilderTextField(
      name: "nombres",
      controller: _nombresController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin('Nombres', true),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.minLength(
          2,
          errorText: 'Los nombres deben tener al menos 2 caracteres',
        ),
        FormBuilderValidators.maxLength(
          50,
          errorText: 'Los nombres no pueden exceder 50 caracteres',
        ),
        (value) {
          if (value == null || value.isEmpty) return null;
          final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$');
          if (!regex.hasMatch(value)) {
            return 'Los nombres solo pueden contener letras y espacios';
          }
          return null;
        },
      ]),
      keyboardType: TextInputType.text,
    );
  }

  Widget inputTextApellidos() {
    return FormBuilderTextField(
      name: "apellidos",
      controller: _apellidosController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin('Apellidos', true),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.minLength(
          2,
          errorText: 'Los apellidos deben tener al menos 2 caracteres',
        ),
        FormBuilderValidators.maxLength(
          50,
          errorText: 'Los apellidos no pueden exceder 50 caracteres',
        ),
        (value) {
          if (value == null || value.isEmpty) return null;
          // Permite letras, espacios, guiones y caracteres acentuados
          final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\-]+$');
          if (!regex.hasMatch(value)) {
            return 'Los apellidos solo pueden contener letras, espacios y guiones';
          }
          return null;
        },
      ]),
      keyboardType: TextInputType.text,
    );
  }

  Widget inputTextTelefono() {
    return FormBuilderTextField(
      name: "telefono",
      controller: _telefonoController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Utils.estiloLetraInput(),
      decoration: Utils.estiloInputTextFiledLogin('Teléfono/Celular', true),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
        FormBuilderValidators.numeric(
          errorText: 'El teléfono debe contener solo números',
        ),
        FormBuilderValidators.minLength(
          7,
          errorText: 'El teléfono debe tener al menos 7 dígitos',
        ),
        FormBuilderValidators.maxLength(
          15,
          errorText: 'El teléfono no puede exceder 15 dígitos',
        ),
      ]),
      keyboardType: TextInputType.phone,
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
          color: Utils.colorAzul(0.8),
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
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: Helpers.errorCampoRequerido),
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
            final authResponse = await supabase.auth.signUp(
              emailRedirectTo: kIsWeb
                  ? null
                  : 'io.supabase.unishare://login-callback',
              email: _emailController.text.toString(),
              password: _passwordController.text.toString(),
            );
            if (authResponse.user != null) {
              final userId = authResponse.user!.id;
              log("Usuario registrado en Auth, ID: $userId");
              final databaseUsuarios = DatabaseUsuarios();
              await databaseUsuarios.crearUsuario(
                _emailController.text.toString(),
                _ciController.text.toString(),
                _nombresController.text.toString(),
                _apellidosController.text.toString(),
                _telefonoController.text.toString(),
                userId, // Pasar el userId que nos devolvió el signUp
              );
            }
            Get.to(HomePage(), duration: Duration(milliseconds: 500));
            Utils.showSnakbarOK("Éxito", "Cuenta creada correctamente revise su correo electronico.", 4);
          } catch (e) {
            Utils.showSnakbarError(
              "Error",
              "¡Error al intentar crear cuenta en UniShare!",
              4,
            );
          } finally {
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
      child: Utils.elevatedButton("CANCELAR", Utils.primaryColor, () {
        log("presionaste el boton cancelar ::::> ${loadingC.getLoading}");
        Navigator.pop(context);
      }, 14.0),
    );
  }
}
