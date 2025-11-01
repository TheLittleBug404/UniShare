import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/utils/helpers/helpers.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/utils/utils_forms/utils_forms.dart';

class RegistroValidoPage extends StatefulWidget {
  static const String titlePage = 'Información del usuario';
  static const String route = '/registro_validado_page';
  static const IconData icon = Icons.person_add;

  final String emailRegistro;
  final String passwordRegistro;

  const RegistroValidoPage({
    super.key,
    required this.emailRegistro,
    required this.passwordRegistro,
  });

  @override
  State<RegistroValidoPage> createState() => _RegistroValidoPageState();
}

class _RegistroValidoPageState extends State<RegistroValidoPage> {
  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();
  String tipoDocSeleccionado = UtilsForms.tiposDocumento[0]['valor']!;
  String extensionSeleccionado = UtilsForms.extensiones[0]['valor']!;
  String _fecha = '';
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _numeroDocumentoController =
      TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _telefonoController1 = TextEditingController();
  final TextEditingController _fechaCumpleController = TextEditingController();

  String mail = '';
  String names = '';
  String lastName = '';
  String motherLastname = '';
  String identificationNumber = '';
  String extension = '';
  String complement = '';
  String cellPhoneNumber = '';
  String phoneNumber = '';
  String birthdate = '';
  String password = '';
  String idType = '';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        progressIndicator: Utils.loadingCustom(),
        color: Colors.white.withValues(alpha: 0.6),
        isLoading: _loading,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKeyRegister,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Utils.espacio10,
                Utils.uniShareLogo(),
                Utils.espacio10,
                Center(
                  child: Utils.estiloTexto(
                    RegistroValidoPage.titlePage,
                    20.0,
                    true,
                  ),
                ),

                Utils.espacio20,

                // CÉDULA DE IDENTIDAD y NÚMERO DE IDENTIFICACIÓN
                Row(
                  children: [
                    Expanded(
                      child: _creaDropdown(
                        Icons.account_box,
                        UtilsForms.tiposDocumento,
                        tipoDocSeleccionado,
                        'Tipo de documento de identidad',
                        (String? val) {
                          setState(() {
                            idType = val!;
                          });
                        },
                      ),
                    ),
                    Utils.espacio10,
                    SizedBox(
                      width: Get.width * 0.4,
                      child: _inputTextNumber(
                        "ci",
                        _numeroDocumentoController,
                        "Nro. de CI",
                      ),
                    ),
                  ],
                ),

                Utils.espacio20,

                //  EXTENSIÓN y  NÚMERO DE COMPLEMENTO
                _creaDropdown(
                  Icons.check_circle_outline,
                  UtilsForms.extensiones,
                  extensionSeleccionado,
                  'Extensión',
                  (String? val) {
                    setState(() {
                      extension = val!;
                    });
                  },
                ),
                Utils.espacio20,
                Divider(color: Utils.colorFondoSecundario(0.3), thickness: 3.0),
                // NOMBRES
                _inputTextString("nombres", _nombresController, "Nombre(s)"),
                Utils.espacio15,
                // PRIMER APELLIDO
                Row(
                  children: [
                    Expanded(
                      child: _inputTextString(
                        "primerapellido",
                        _apellidoPaternoController,
                        "Primer apellido",
                      ),
                    ),
                    Utils.espacio10,
                    Expanded(
                      child: _inputTextString(
                        "segundopellido",
                        _apellidoMaternoController,
                        "Segundo apellido",
                        false,
                      ),
                    ),
                  ],
                ),
                Utils.espacio10,

                // CAJA DE FECHA DE NACIMIENTO
                _creaCajaTextoFecha(
                  Icons.perm_contact_calendar,
                  'Fecha de nacimiento',
                  TextInputType.datetime,
                  birthdate,
                ),
                Utils.espacio10,

                // NÚMERO DE TELÉFONO o CELULAR
                Row(
                  children: [
                    Expanded(
                      child: _inputTextNumber(
                        "telefono1",
                        _telefonoController1,
                        "Celular / teléfono",
                      ),
                    ),
                    Utils.espacio10,
                    /*SizedBox(
                      width: Get.width * 0.4,
                      child: _inputTextNumber("telefono1", _telefonoController2,
                          "Cel./Telf. (Alternativo)", false),
                    )*/
                  ],
                ),

                Utils.espacio20,

                _botonRegistrar(context),

                Utils.espacio20,

                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: Utils.elevatedButton(
                    "CANCELAR",
                    Utils.colorFondoSecundario(0.8), //Utils.colorGuindo(0.8),
                    () {
                      Get.offAllNamed(HomePage.route);
                      //Navigator.pushReplacementNamed(context, HomePage.route);
                    },
                    14.0,
                  ),
                ),
                Utils.espacio30,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _creaDropdown(
    IconData icon,
    List<Map<String, String>> opts,
    String optSeleccionado,
    String title,
    Function(String?)? onSave,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FormBuilderDropdown(
            name: "ci",
            initialValue: optSeleccionado,
            items: _getOpcionesTipoDocumento(opts),
            onChanged: (opt) {
              setState(() {
                optSeleccionado = opt.toString();
              });
            },
            onSaved: onSave,
            decoration: estiloInputText(title),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getOpcionesTipoDocumento(
    List<Map<String, String>> opts,
  ) {
    List<DropdownMenuItem<String>> lista = [];
    for (var item in opts) {
      lista.add(
        DropdownMenuItem(
          value: item['valor'],
          child: Text(item['titulo']!, style: const TextStyle(fontSize: 12.0)),
        ),
      );
    }
    return lista;
  }

  _botonRegistrar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: Utils.elevatedButton("REGISTRAR", Utils.colorTextoBordesIconos, () {
        final form = _formKeyRegister.currentState;
        if (form!.validate()) {
          form.save();
          showConfirmRegister(
            context,
            '¡Atención!',
            //'¡Atención!',
            Utils.colorAzul(0.8),
            '¿Esta seguro(a) de registrar la cuenta con el correo electrónico ${widget.emailRegistro}?',
          );
        } else {
          Utils.showAlert(
            context,
            '¡Error!',
            Colors.red,
            "Datos incorrectos, revise nuevamente por favor.",
          );
        }
      }, 14.0),
    );
  }

  // ignore: unused_element
  /*Future<void> _submit() async {
    mail = widget.emailRegistro;
    password = widget.passwordRegistro;
    final respDecode = await user.registroUsuario(
      mail,
      _nombresController.text, //names,
      _apellidoPaternoController.text, //lastName,
      _apellidoMaternoController.text, // motherLastname,
      _numeroDocumentoController.text, //identificationNumber,
      extension,
      _complementoController.text, //complement,
      _telefonoController1.text, //phoneNumber,
      '', //_telefonoController2.text, //cellPhoneNumber,
      birthdate,
      password,
      int.parse(idType.trim()),
    );

    if (respDecode['state'] == '00') {
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
      Utils.showSnakbarOK(
        "Aviso",
        "Se envió su registro de habilitación de cuenta, verifique su correo electrónico para la habilitación",
        4,
      );
      Navigator.pushReplacementNamed(context, LoginPage.route);
    } else {
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
      Utils.showAlert(
        context,
        'Error',
        Colors.red,
        respDecode['message'].toString(),
      );
    }
  }*/

  void showConfirmRegister(
    BuildContext context,
    String title,
    Color colorTitle,
    String msg,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: colorTitle)),
          content: Text(msg),
          actions: <Widget>[
            Utils.elevatedButton(
              "REGISTRAR",
              Utils.colorTextoBordesIconos,
              () async {
                //Navigator.pop(context);//aumente esta linea
                setState(() {
                  _loading = true;
                });
                //await _submit();
                log('_submit future');
              },
              14.0,
            ),
            Utils.elevatedButton(
              "CANCELAR", 
              Utils.primaryColor, 
              () {
                setState(() {
                  _loading = false;
                });
                Navigator.pop(context);
              }, 
              14.0,
            ),
          ],
        );
      },
    );
  }

  _creaCajaTextoFecha(
    IconData icon,
    String title,
    TextInputType type,
    String parametroRest,
  ) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FormBuilderTextField(
            name: "Fecha de nacimiento",
            enableInteractiveSelection: false,
            keyboardType: type,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black.withValues(alpha: 0.8),
            ),
            decoration: estiloInputText(title),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              await _showDate(context);
            },
            onSaved: (val) {
              birthdate = val!;
            },
            controller: _fechaCumpleController,
          ),
        ),
        const SizedBox(width: 3.0),
      ],
    );
  }

  Future<void> _showDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _fechaCumpleController.text = _fecha.substring(0, 10);
      });
    }
  }

  _inputTextString(
    String name,
    TextEditingController txtcontroller,
    String label, [
    bool requerido = true,
  ]) {
    return FormBuilderTextField(
      name: name,
      controller: txtcontroller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      //style: Utils.estiloLetraInput(),
      onChanged: null,
      validator: FormBuilderValidators.compose([
        requerido
            ? FormBuilderValidators.required(
                errorText: Helpers.errorCampoRequerido,
              )
            : (val) => null,
        FormBuilderValidators.maxLength(
          50,
          errorText: "Caracteres permitidos 50",
        ),
      ]),
      keyboardType: TextInputType.text,
      decoration: estiloInputText(label),
    );
  }

  _inputTextNumber(
    String name,
    TextEditingController txtcontroller,
    String label, [
    bool requerido = true,
  ]) {
    return FormBuilderTextField(
      name: name,
      controller: txtcontroller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      //style: Utils.estiloLetraInput(),
      onChanged: null,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.numeric(errorText: Helpers.errorNumeroFormato),
        FormBuilderValidators.maxLength(12),
        requerido
            ? FormBuilderValidators.required(
                errorText: Helpers.errorCampoRequerido,
              )
            : (val) => null,
      ]),
      keyboardType: TextInputType.number,
      decoration: estiloInputText(label),
    );
  }

  InputDecoration estiloInputText(String label) => InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 20.0, 10.0),
    labelStyle: TextStyle(color: Utils.primaryColor, fontSize: 12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Utils.colorAzul(0.4), //Utils.colorAmarillo(0.4),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Utils.colorFondoSecundario(0.8), //color: Utils.colorVerde(0.8),
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
