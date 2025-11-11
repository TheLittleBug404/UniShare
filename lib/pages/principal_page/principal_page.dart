import 'dart:developer';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/controllers/navigation_controller/navigation_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/pages/libros_page/libros_page.dart';
import 'package:uni_share/pages/materias_carrera_page/materias_carrera_page.dart';
import 'package:uni_share/pages/notificaciones_page/notificaciones_page.dart';
import 'package:uni_share/pages/subir_material_page/subir_material_page.dart';
import 'package:uni_share/pages/visitanos_page/visitanos_page.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/widgets/datos_usuario/datos_usuario.dart';

class PrincipalPage extends StatefulWidget {
  static String route = '/principal_page';
  static String title = 'Principal';
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final nc = Get.find<NavigationController>();

  final List<Widget> _widgetOptions = [];
  final List<String> _pagesRoutes = [];
  final List<TabItem> _botones = [];

  final lc = Get.find<LoginController>();
  int indexNav = 0;
  //late ConvexTabController tabController = ConvexTabController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //indexNav = lc.getListSuministros().isEmpty ? 1 : 0;
    log("Ingresa a INITSTATE indexNav: $indexNav");
    nc.setIndexPage(indexNav);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nc.setIndexPage(indexNav);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOpciones = <Widget>[
      VisitanosPage(),
      MateriasCarreraPage(),
      NotificacionesPage(),
      SubirMaterialPage(),
      LibrosPage(),
    ];
    List<String> pagesRutas = const <String>[
      "",
      MateriasCarreraPage.route,
      NotificacionesPage.route,
      LibrosPage.route,
      VisitanosPage.route,
      SubirMaterialPage.route,
    ];
    List<TabItem> botonesItems = <TabItem>[
      TabItem(
        icon: VisitanosPage.icon,
        title: VisitanosPage.titlePage,
      ),
      TabItem(
        icon: MateriasCarreraPage.icon,
        title: MateriasCarreraPage.smallTitlePage,
      ),
      TabItem(
        icon: NotificacionesPage.icon,
        title: NotificacionesPage.smallTitlePage,
      ),
    ];

    if (lc.getAuth) {
      _widgetOptions.clear();
      _widgetOptions.addAll(widgetOpciones);
      _pagesRoutes.clear();
      _pagesRoutes.addAll(pagesRutas);
      _botones.clear();
      _botones.addAll(botonesItems);
    }
    return Obx(
      () => Scaffold(
        endDrawer: _createDrawer(_pagesRoutes.elementAt(nc.getIndexPage)),
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        body: _widgetOptions.elementAt(nc.getIndexPage),
        bottomNavigationBar: StyleProvider(
          style: Style(),
          child: ConvexAppBar(
            curveSize: 80,
            initialActiveIndex: 0,
            top: -17,
            color: Colors.white,
            backgroundColor: Utils.colorTextoBordesIconos,
            height: Get.height * 0.08,
            items: _botones,
            onTap: (index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                nc.setIndexPage(index);
              });
              log("imprimiendo index $index");
              if (index != nc.getIndexPage) {}
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Drawer _createDrawer(String routeCurrent) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _infoUser(),
                  Column(
                    children: [
                      _creaItemSubMenu(
                        VisitanosPage.titlePage,
                        routeCurrent,
                        VisitanosPage.route,
                        VisitanosPage.icon,
                        0, //5:
                      ),
                      _creaItemSubMenu(
                        MateriasCarreraPage.titlePage,
                        routeCurrent,
                        MateriasCarreraPage.route,
                        MateriasCarreraPage.icon,
                        1,
                      ),
                      _creaItemSubMenu(
                        NotificacionesPage.titlePage,
                        routeCurrent,
                        NotificacionesPage.route,
                        NotificacionesPage.icon,
                        2,
                      ),
                      _creaItemSubMenu(
                        SubirMaterialPage.titlePage,
                        routeCurrent,
                        SubirMaterialPage.route,
                        SubirMaterialPage.icon,
                        3,
                      ),
                      _creaItemSubMenu(
                        LibrosPage.titlePage,
                        routeCurrent,
                        LibrosPage.route,
                        LibrosPage.icon,
                        4,
                      ),
                      lc.getAuth
                          ? _creaItemSubMenu(
                              "Cerrar sesión",
                              "Cerrar",
                              HomePage.route,
                              Icons.power_settings_new,
                              -1,
                            )
                          : const SizedBox(height: 50.0),
                      _creaItemSubMenu(
                        "Versión: ${Utils.isAndroid ? Constantes.versAppAndroid : Constantes.versAppApple}",
                        "-",
                        "",
                        Icons.info_outlined,
                        -3,
                        "",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _redesSociales(),
        ],
      ),
    );
  }

  ListTile _creaItemSubMenu(
    String titulo,
    String ruta,
    String rutaPage,
    IconData icono,
    int indexP, [
    String? urlPage,
  ]) {
    return ListTile(
      trailing: Icon(
        icono,
        size: 20,
        color: Get.isDarkMode
            ? Utils.colorFondoSecundario(0.9)
            : Utils.colorTextoBordesIconos,
      ),
      leading: rutaPage.isEmpty
          ? SizedBox.shrink()
          : Icon(
              Icons.chevron_left,
              size: 20,
              color: Utils.colorAzul(0.9), //Utils.colorGuindo(0.9)
            ),
      title: ruta == rutaPage
          ? Utils.estiloTexto(titulo, 12, false, Utils.colorAzul(0.9))
          : Utils.estiloTexto(titulo, 12, false, Utils.colorTextoBordesIconos),
      selected: ruta == rutaPage, //Color opción seleccionada
      splashColor: Utils.colorFondoSecundario(0.5),
      enabled: ruta != rutaPage ? true : false,
      onTap: () async {
        bool hasInternet = await Utils.hasInternet();
        if (titulo.contains('Cerrar')) {
          Utils.showConfirmCloseApp(
            "¡Atención!",
            "¿Está seguro(a) de cerrar la sesión?",
          );
        } else {
          if (indexP == -1) {
            Get.offNamed(rutaPage);
          } else if (indexP == -2) {
            if (hasInternet) {
              //Get.to(DlpWebViewPage(titlePage: titulo, urlPage: urlPage!));
            } else {
              // Muestra un Snackbar si no hay conexión a internet
              Utils.showSnakbarSinInternet(
                'ATENCIÓN',
                'Sin acceso a internet, por favor inténtelo más tarde',
                4,
              );
            }
          } else if (indexP == -3) {
          } else {
            if (mounted) {
              Navigator.pop(context);
            }
            nc.setIndexPage(indexP);
            setState(() {
              //_selectedIndex = indexP;
            });
          }
        }
      },
    );
  }

  Widget _infoUser() {
    final white = Colors.white.withValues(alpha: 0.98);
    return SizedBox(
      height: 200,
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Utils.primaryColor),
        accountName: lc.getNameGoogle != "null"
            ? Utils.estiloTexto(
                lc.getNameGoogle,
                12.0,
                true,
                Colors.white.withValues(alpha: 1),
              )
            : null,
        accountEmail: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (lc.getAuth) ...[
              Utils.estiloTexto("Usuario", 12.0, false, Colors.white),
            ] else ...[
              const Text(
                'Visitante',
                style: TextStyle(color: Utils.colorTextoBordesIconos),
              ),
            ],
          ],
        ),
        currentAccountPicture: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.0, color: Colors.white),
            ),
            child: lc.getPhotoGoogle.isNotEmpty
                ? _photoGoogle()
                : Icon(Icons.account_circle_rounded, size: 62.0, color: white),
          ),
        ),
        onDetailsPressed: lc.getAuth
            ? () async {
                Utils.showAwesomeDialog(
                  DatosUsuario.titlePage,
                  DatosUsuario(),
                );
              }
            : null,
      ),
    );
  }

  _redesSociales() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _botonRedSocial("fb"),
        _botonRedSocial("tk"),
        _botonRedSocial("web"),
        _botonRedSocial("it"),
      ],
    );
  }

  _botonRedSocial(String t) {
    String url;
    FaIcon icono;
    switch (t) {
      case 'fb':
        icono = const FaIcon(
          FontAwesomeIcons.squareFacebook,
          color: Color.fromRGBO(59, 89, 152, 0.9),
        );
        url = "https://www.facebook.com/CarreraDeInformaticaUmsa";
        break;
      case 'tk':
        icono = const FaIcon(
          FontAwesomeIcons.tiktok,
          color: Color.fromRGBO(0, 0, 0, 1),
        );
        url = "https://www.tiktok.com/@carrera.informatica";
        break;
      case 'web':
        icono =
            // ignore: deprecated_member_use
            const FaIcon(FontAwesomeIcons.globeAmericas, color: Colors.blue);
        url = "http://informatica.umsa.bo/";
        break;
      default:
        icono = const FaIcon(
          FontAwesomeIcons.squareInstagram,
          color: Color.fromRGBO(199, 75, 193, 0.898),
        );
        url = "https://www.instagram.com/informatica_umsa/";
        break;
    }
    return IconButton(
      iconSize: 30.0,
      icon: icono,
      onPressed: () async {
        Utils.launchInBrowser(url);
      },
    );
  }

  _photoGoogle() => Image.network(lc.getPhotoGoogle);
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 12, color: color);
  }
}
