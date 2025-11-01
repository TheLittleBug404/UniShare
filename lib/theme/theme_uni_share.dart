import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_share/utils/utils/utils.dart';


class ThemeUniShare with ChangeNotifier {
  static ThemeData light() {
    TextButtonThemeData x = TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade600,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    return ThemeData(
      useMaterial3: true,
      textButtonTheme: x,
      brightness: Brightness.light,
      primaryColor: Utils.primaryColor,
      splashColor: Utils.colorFondoSecundario(0.8), //todo creo que este tambien
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.grey,
        secondary: Utils.colorTextoBordesIconos,
      ),
      textTheme: GoogleFonts.abelTextTheme(ThemeData.light().textTheme),
      //textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
    );
  }

  static ThemeData dark() {
    TextButtonThemeData x = TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    return ThemeData(
      useMaterial3: true,
      textButtonTheme: x,
      brightness: Brightness.light,
      primaryColor: Utils.primaryColor,
      splashColor: Utils.colorFondoSecundario(0.8), //todo creo que este es
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.grey,
        secondary: Utils.colorTextoBordesIconos,
      ),
      textTheme: GoogleFonts.abelTextTheme(ThemeData.light().textTheme),
      //textTheme: GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
    );
  }

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  void setTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }
}
