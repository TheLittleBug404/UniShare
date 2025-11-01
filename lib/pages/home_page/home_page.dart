import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/controllers/navigation_controller/navigation_controller.dart';
import 'package:uni_share/pages/login_page/login_page.dart';
import 'package:uni_share/pages/main_page/main_page.dart';
import 'package:uni_share/utils/utils/utils.dart';

class HomePage extends StatefulWidget {
  static const String titlePage = 'Inicio';
  static const String smallTitlePage = 'Inicio';
  static const String route = '/home_page';
  static const IconData icon = Icons.home_outlined;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final lc = Get.find<LoginController>();
  final nc = Get.find<NavigationController>();
  final bool _loading = false;
  List<Widget> _pages = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [_paginaBienvenida()];
  }

  Widget _paginaBienvenida() {
    return Stack(
      children: <Widget>[
        Utils.fondo(), //colores de fondo
        uniShareLogoSlogan(),
      ],
    );
  }

  Widget uniShareLogoSlogan() {
    return SizedBox(
      height: Get.height,
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Utils.espacio30,
            SizedBox(height: Get.height * 0.8, child: Utils.uniShareLogo()),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Utils.espacioV20()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (sw, d) async {
        if (!sw) {
          Utils.showConfirmCloseAndOut(
            context,
            "¡Atención!",
            Utils.colorBottonNavigationBar(0.8),
            "¿Está seguro(a) de salir de la aplicación?",
          );
        }
      },
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: _loading,
          progressIndicator: Utils.loadingCustom(),
          color: Colors.white.withValues(alpha: 0.6), 
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButton: _floatingActinButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: _bottonNaviagationBarUniShare(context),
      ),
    );
  }
  Widget _floatingActinButton() {
    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: Utils.primaryColor,
          width: 4,
        ),
      ),
      child: RawMaterialButton(
        shape: const CircleBorder(),
        elevation: 0.0,
        splashColor: Utils.colorFondosSecundariosBordesSuaves,
        child: Icon(
          Icons.waving_hand,
          color: Utils.primaryColor,
          size: 27.0,
        ),
        onPressed: () {
          Utils.showSnakbarInfo(
            'BIENVENIDO',
            '¡Bienvenido a UNI SHARE! Comparte y descubre recursos educativos de la carrera de Informática. ¡Empieza a explorar y a colaborar con otros usuarios!',
            6,
          );
        },
      ),
    );
  }
  Widget _bottonNaviagationBarUniShare(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Utils.colorTextoBordesIconos,
      showUnselectedLabels: true,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (value) async {
        await _redirectRegistroLoginVisita(value);
      },
      items: _listButtonsNavBar(),
    );
  }
  _listButtonsNavBar() {
    List<BottomNavigationBarItem> list = [
      if (!lc.getAuth) ...[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.input,
            size: 25.0,
          ),
          label: 'Ingresar',
        ),
      ],
      BottomNavigationBarItem(
        icon: Icon(
          lc.getAuth ? Icons.input : Icons.exit_to_app,
          size: 25.0,
        ),
        label: lc.getAuth ? 'Ingresar' : 'Salir',
      ),
      if (lc.getAuth) ...[
        BottomNavigationBarItem(
          icon: Obx(
            () => Icon(
              Icons.exit_to_app, //Icons.notification_important_outlined
              color: _selectedIndex == 1
                  ? Colors.greenAccent
                  : Colors.redAccent,
              size: 25.0,
            ),
          ),
          label: 'Salir',
        )
      ],
    ];
    return list;
  }
  Future<void> _redirectRegistroLoginVisita(int opcion) async {
    switch (opcion) {
      case 2:
        if (!lc.getAuth) {
          Get.to(
            MainPage(),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500),
          );
        } else {
          setState(() {
            _selectedIndex = 1;
          });
        }

        break;
      case 1:
        if (!lc.getAuth) {
          Utils.showConfirmCloseAndOut(
            context,
            "¡Atención!",
            Utils.colorBottonNavigationBar(0.8),
            "¿Está seguro(a) de salir de la aplicación?",
          );
        } else {
          nc.setIndexPage(0);
          Utils.showConfirmCloseApp(
            "¡Atención!",
            "¿Está seguro(a) de cerrar la sesión?",
          );
        }
        break;
      case 0:
        if (!lc.getAuth) {
          Get.to(
            LoginPage(),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500),
          );
        } else {
          Get.to(
            MainPage(),
            transition: Transition.fadeIn,
            duration: Duration(milliseconds: 500),
          );
        }
        break;
    }
  }
}
