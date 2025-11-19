import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/navigation_controller/navigation_controller.dart';
import 'package:uni_share/utils/utils/utils.dart';

class CustomScrollViewWidget extends StatelessWidget {
  final Color colorFondo;
  final String imagenFondo;
  final String titulo;
  final SliverList silverList;

  const CustomScrollViewWidget({
    super.key,
    required this.colorFondo,
    required this.imagenFondo,
    required this.titulo,
    required this.silverList,
  });

  @override
  Widget build(BuildContext context) {
    final nc = Get.find<NavigationController>();
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              log("Mostramos el indice de pagina ${nc.getIndexPage}");
              if (nc.getIndexPage == 1) {
                nc.setIndexPage(0);
              }
              if (nc.getIndexPage == 2) {
                nc.setIndexPage(1);
              }
              if (nc.getIndexPage == 3) {
                nc.setIndexPage(1);
              }
              if (nc.getIndexPage == 5) {
                nc.setIndexPage(1);
              }
            },
            // Si no se proporciona onBackPressed, usa el comportamiento por defecto
          ),
          backgroundColor: colorFondo,
          foregroundColor: Colors.white,
          pinned: true,
          expandedHeight: 210.0,
          flexibleSpace: FlexibleSpaceBar(
            /*background: FadeInImage(
              fit: BoxFit.cover,
              placeholder: AssetImage(imagenFondo),
              image: AssetImage(imagenFondo),
              fadeInDuration: const Duration(seconds: 2),
            ),*/
            background: Stack(
              children: [
                FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage(imagenFondo),
                  image: AssetImage(imagenFondo),
                  fadeInDuration: const Duration(seconds: 2),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8), // Más oscuro
                        Colors.black.withValues(alpha: 0.3), // Medio
                        Colors.transparent, // Transparente
                      ],
                      stops: [0.0, 0.5, 0.8], // Ocupa el 80% superior
                    ),
                  ),
                ),
              ],
            ),
            title: Card(
              color: Colors.black.withValues(alpha: .3),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Utils.estiloTexto(titulo, 18, true, Colors.white),
              ),
            ),
            titlePadding: EdgeInsets.only(left: 0, bottom: 15),
            centerTitle: true,
          ),
        ),
        silverList,
      ],
    );
  }
}
