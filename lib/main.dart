import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/controllers/material_controller/material_controller.dart';
import 'package:uni_share/controllers/navigation_controller/navigation_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/pages/loading_page/loading_page.dart';
import 'package:uni_share/pages/login_page/login_page.dart';
import 'package:uni_share/pages/principal_page/principal_page.dart';
import 'package:uni_share/pages/registro_page/registro_page.dart';
import 'package:uni_share/theme/theme_uni_share.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  await Supabase.initialize(
    url: supabaseUrl, 
    anonKey: supabaseAnonKey,
  );
  runApp(const MainApp());
  Get.put(LoginController());
  Get.put(NavigationController());
  Get.put(LoadingController());
  Get.put(MaterialController());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constantes.title,
      enableLog: false,
      theme: ThemeUniShare.light(),
      darkTheme: ThemeUniShare.dark(),
      themeMode: ThemeMode.system,
      locale: Locale('es'),
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: Utils.isAndroid ? LoadingPage.route : HomePage.route,
      getPages: [
        GetPage(name: LoadingPage.route, page: () => const LoadingPage()),
        GetPage(name: HomePage.route, page: () => const HomePage()),
        GetPage(name: LoginPage.route, page: () => const LoginPage()),
        GetPage(name: RegistroPage.route, page: () => const RegistroPage()),
        GetPage(name: PrincipalPage.route,page: () => const PrincipalPage()),
      ],
    );
  }
}
