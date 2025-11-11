import 'package:flutter/material.dart';
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: colorFondo,
          foregroundColor: Colors.white,
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            background: FadeInImage(
              fit: BoxFit.cover,
              placeholder: AssetImage(imagenFondo),
              image: AssetImage(imagenFondo),
              fadeInDuration: const Duration(seconds: 2),
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
