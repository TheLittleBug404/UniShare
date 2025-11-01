import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Utils {
  static const primaryColor = Color(0xFF1E88E5);
  static const primaryColor2 = Color(0xFF64B5F6);
  static const colorTextoBordesIconos = Color(0xFF424242);
  static const colorConfirmacion = Color(0xFF26A69A);
  static const colorErroresAdvertencias = Color(0xFFE53935);
  static const colorFondoPrincipal = Color(0xFFFFFFFF);
  static const colorFondosSecundariosBordesSuaves = Color(0xFFBDBDBD);
  //variables de espacio
  static get espacio00 => const SizedBox(height: 00.0, width: 00.0);
  static get espacio05 => const SizedBox(height: 05.0, width: 05.0);
  static get espacio10 => const SizedBox(height: 10.0, width: 10.0);
  static get espacio15 => const SizedBox(height: 15.0, width: 15.0);
  static get espacio20 => const SizedBox(height: 20.0, width: 20.0);
  static get espacio25 => const SizedBox(height: 25.0, width: 25.0);
  static get espacio30 => const SizedBox(height: 30.0, width: 30.0);
  static get espacio35 => const SizedBox(height: 35.0, width: 35.0);
  static get espacio40 => const SizedBox(height: 40.0, width: 40.0);
  static get espacio45 => const SizedBox(height: 45.0, width: 45.0);
  static get espacio50 => const SizedBox(height: 50.0, width: 50.0);
  static get espacio55 => const SizedBox(height: 55.0, width: 55.0);
  static get espacio60 => const SizedBox(height: 60.0, width: 60.0);
  static espacioV05() => const SizedBox(height: 05.0);
  static espacioV10() => const SizedBox(height: 10.0);
  static espacioV15() => const SizedBox(height: 15.0);
  static espacioV20() => const SizedBox(height: 20.0);
  static espacioV25() => const SizedBox(height: 25.0);
  static espacioV30() => const SizedBox(height: 30.0);
  static espacioV35() => const SizedBox(height: 35.0);
  static espacioV40() => const SizedBox(height: 40.0);
  static espacioV45() => const SizedBox(height: 45.0);
  static espacioV50() => const SizedBox(height: 50.0);

  //saber si es android o IOS
  static bool get isAndroid => Platform.isAndroid;

  //colores de mis compomentes
  static Color colorBottonNavigationBar(double opacidad) {
    return colorTextoBordesIconos;
  }

  static Color colorFondoSecundario(double opacidad) {
    return primaryColor2;
  }

  static Color colorAzul(double opacidad) {
    return Color.fromRGBO(100, 181, 246, opacidad);
  }

  static Color colorPrimario(double opacidad) {
    return primaryColor;
  }

  //loading carga
  static loadingCustom([double? size]) => Center(
    child: SpinKitCircle(
      color: Get.isDarkMode
          ? Utils.colorFondoSecundario(0.8)
          : Utils.colorFondoSecundario(0.8),
      size: size ?? 50.0,
    ),
  );
  //logos de la aplicacion y fondos
  static Widget uniShareLogo() {
    return const FadeInImage(
      placeholder: AssetImage('assets/img/logo_unishare.webp'),
      image: AssetImage('assets/img/logo_unishare.webp'),
      fadeInDuration: Duration(seconds: 2),
    );
  }

  static fondo() {
    final fondo = SizedBox(height: Get.height, width: double.infinity);
    final colorArriba = colorAzul(0.3);
    final colorAbajo = colorAzul(0.3);
    return Stack(
      children: <Widget>[
        fondo,
        Positioned(
          top: -Get.height * 0.1,
          right: -Get.height * 0.1,
          child: circulo(Get.height * 0.45, colorArriba),
        ),
        const SizedBox(height: 200.0),
        Positioned(
          bottom: -Get.height * 0.1,
          left: -Get.height * 0.1,
          child: circulo(Get.height * 0.40, colorAbajo),
        ),
      ],
    );
  }

  static Widget circulo(double wh, Color color) {
    return Container(
      width: wh,
      height: wh,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(color: color, width: 0.0), //20,0
        boxShadow: [
          BoxShadow(
            color: color,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  //seccion de snackBars
  static void showSnakbarError(
    String titulo,
    String msg,
    int duracion, [
    SnackPosition? position,
  ]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        titulo,
        msg,
        titleText: estiloTexto(titulo, 16.0, true, Colors.white),
        colorText: Colors.white.withValues(alpha: 0.8),
        snackPosition: position ?? SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900.withValues(alpha: 0.9),
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        borderColor: Colors.white.withValues(alpha: 0.8),
        borderWidth: 1,
        icon: const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(Icons.error_outline, color: Colors.white, size: 35.0),
        ),
        duration: Duration(seconds: duracion),
      );
    });
  }

  static void showSnakbarInfo(
    String titulo,
    String msg,
    int duracion, [
    SnackPosition? position,
  ]) {
    Get.snackbar(
      titulo,
      msg,
      titleText: estiloTexto(titulo, 16.0, true, colorTextoBordesIconos),
      colorText: colorTextoBordesIconos,
      snackPosition: position ?? SnackPosition.BOTTOM,
      backgroundColor: colorFondoPrincipal,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      borderColor: colorTextoBordesIconos,
      borderWidth: 1,
      icon: const Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Icon(
          Icons.error_outline,
          color: colorTextoBordesIconos,
          size: 35.0,
        ),
      ),
      duration: Duration(seconds: duracion),
    );
  }

  static void showConfirmCloseApp(String titulo, String msg) {
    final lc = Get.find<LoginController>();
    Get.defaultDialog(
      title: titulo,
      content: Text(msg, style: TextStyle(color: Utils.colorTextoBordesIconos)),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(backgroundColor: colorTextoBordesIconos),
          onPressed: () async {
            lc.setAuth(false);
            // await DBProvider.db.deleteTable(Constantes.tablaUsuario);
            // await DBProvider.db.deleteTable(Constantes.tablaTokenFireBase);
            // if (Platform.isAndroid) {
            //   await LoginServiceGoogle().logoutGoogle();
            // }
            Get.back();
            Get.offAllNamed(HomePage.route);
          },
          child: estiloTexto('Aceptar', 14.0, true, Colors.white),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () => Get.back(),
          child: estiloTexto('Cancelar', 14.0, true, Colors.white),
        ),
      ],
    );
  }

  static Future<T?> showAwesomeDialog<T>(
    String title,
    Widget body, [
    bool? sinBotonok = false,
  ]) async {
    return await Get.defaultDialog(
      radius: 10,
      title: title,
      titleStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? primaryColor : Utils.primaryColor,
      ),
      content: body,
      backgroundColor: Get.isDarkMode
          ? Colors.black.withValues(alpha: 0.7)
          : Colors.white,
      actions: sinBotonok!
          ? []
          : [
              elevatedButton(
                "Cerrar",
                Utils.colorTextoBordesIconos,
                () => Get.back(),
                14,
              ),
            ],
    );
  }

  static Future<void> showAlert(
    BuildContext context,
    String title,
    Color colorTitle,
    String msg,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: colorTitle)),
          content: Text(
            msg,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: Utils.estiloBoton(Colors.transparent),
              onPressed: () => Navigator.of(context).pop(),
              child: estiloTexto("Ok", 18.0, true, colorPrimario(0.9)),
            ),
          ],
        );
      },
    );
  }

  static void showSnakbarOK(
    String titulo,
    String msg,
    int duracion, [
    SnackPosition? position,
  ]) {
    Get.snackbar(
      titulo,
      msg,
      titleText: estiloTexto(titulo, 16.0, true, Colors.white),
      colorText: Colors.white.withValues(alpha: 0.8),
      snackPosition: position ?? SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      borderColor: Colors.white.withValues(alpha: 0.8),
      borderWidth: 1,
      icon: const Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Icon(
          Icons.verified_user_outlined,
          color: Colors.white,
          size: 35.0,
        ),
      ),
      duration: Duration(seconds: duracion),
    );
  }

  //estilos de texto
  static Text estiloTexto(
    String txt,
    double tamanio,
    bool fontWeight, [
    Color? col,
    bool? center,
  ]) => Text(
    txt,
    textAlign: center == true ? TextAlign.center : TextAlign.left,
    style: Get.textTheme.bodyMedium!.copyWith(
      fontSize: tamanio * 1.1,
      fontWeight: fontWeight ? FontWeight.bold : null,
      color: col ?? (Get.isDarkMode ? Colors.white70 : Colors.black87),
    ),
  );

  static estiloLetraInput() => const TextStyle(fontSize: 18);

  static InputDecoration estiloInputTextFiledLogin(
    String hintTextLabel, [
    bool todosBordes = false,
    bool tieneLabel = false,
  ]) {
    bool isDark = Get.isDarkMode;
    return InputDecoration(
      label: tieneLabel ? Text(hintTextLabel) : null,
      labelStyle: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      hintText: hintTextLabel,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[400] : Colors.black87,
        fontSize: 15,
      ),
      fillColor: isDark ? Colors.black87 : Colors.white70,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: todosBordes
            ? const BorderRadius.all(Radius.circular(10))
            : const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
        borderSide: BorderSide(
          color: isDark ? Colors.white38 : Colors.black12,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Utils.colorPrimario(0.8), width: 1),
        borderRadius: todosBordes
            ? const BorderRadius.all(Radius.circular(10))
            : const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: todosBordes
            ? const BorderRadius.all(Radius.circular(10))
            : const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Utils.colorErroresAdvertencias,
          width: 1,
        ),
        borderRadius: todosBordes
            ? const BorderRadius.all(Radius.circular(10))
            : const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
      ),
    );
  }

  static bool isPasswordCompliant(String pass, [int minLength = 6]) {
    String password = pass.trim();
    if (password.isEmpty) {
      return false;
    }
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasMinLength = password.length >= minLength;
    return hasDigits & hasUppercase & hasLowercase & hasMinLength;
  }

  //estilos de botones
  static ButtonStyle estiloBoton(Color color) => ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
    shadowColor: color,
    backgroundColor: color,
    foregroundColor: color,
    disabledForegroundColor: color,
    animationDuration: const Duration(milliseconds: 1),
  );

  static void showConfirmCloseAndOut(
    BuildContext context,
    String title,
    Color colorTitle,
    String msg,
  ) {
    final lc = Get.find<LoginController>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: estiloTexto(title, 20, true, primaryColor),
          content: lc.getAuth
              ? estiloTexto(msg, 14, true, null, true)
              : estiloTexto(
                  "¿Desea salir de la aplicación?",
                  14,
                  true,
                  null,
                  true,
                ),
          actions: <Widget>[
            ElevatedButton(
              style: Utils.estiloBoton(Colors.transparent),
              child: estiloTexto(
                'Confirmar',
                16.0,
                true,
                Utils.colorTextoBordesIconos, //colorVerde(0.9),
              ),
              onPressed: () {
                lc.setAuth(false);
                Navigator.pushReplacementNamed(context, HomePage.route);
                SystemNavigator.pop();
              },
            ),
            ElevatedButton(
              style: Utils.estiloBoton(Colors.transparent),
              onPressed: () => Navigator.of(context).pop(),
              child: estiloTexto(
                'Cancelar',
                16.0,
                true,
                Utils.primaryColor, //colorGuindo(0.9),
              ),
            ),
          ],
        );
      },
    );
  }

  static ElevatedButton elevatedButton(
    String txtboton,
    Color colorBorde,
    VoidCallback voidCallback, [
    double tamanioLetra = 12.0,
    Color colorLetra = Colors.white,
  ]) => ElevatedButton(
    style: Utils.estiloBoton(colorBorde),
    onPressed: voidCallback,
    child: Utils.estiloTexto(txtboton, tamanioLetra, true, colorLetra, true),
  );

  //ocultar teclado
  static void ocultarTeclado(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
