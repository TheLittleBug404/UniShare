import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/utils/utils/utils.dart';

class LoadingPage extends StatelessWidget {
  static const String titlePage = 'Loading';
  static const String route = '/loading_page';
  static final lc = Get.find<LoginController>();
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(body: _buildBody());

  Widget _buildBody() => FutureBuilder<int>(
    future: _initService(),
    initialData: 4,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingUI();
      }
      if (snapshot.data != null && snapshot.data! < 3) {
        return _buildHomePage();
      }
      if (snapshot.hasError) {
        return _buildErrorUI();
      } else {
        return _buildLoadingUI();
      }
    },
  );
  Widget _buildLoadingUI() => Center(
    child: Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: Get.width * 0.8, child: Utils.uniShareLogo()),
        Utils.loadingCustom(),
        Utils.estiloTexto("Cargando...", 14, false),
      ],
    ),
  );

  Widget _buildErrorUI() {
    Utils.showSnakbarError(
      "Error",
      "Ocurrió un error inesperado, por favor ingrese nuevamente.",
      4,
    );
    return HomePage();
  }

  Widget _buildHomePage() => HomePage();

  Future<int> _initService() async{
    return 1;
  }
}
