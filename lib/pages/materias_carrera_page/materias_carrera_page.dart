import 'package:flutter/material.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/widgets/lista_materias/lista_materias.dart';

class MateriasCarreraPage extends StatefulWidget {
  static const String titlePage = 'Materias de carrera';
  static const String smallTitlePage = 'Materias';
  static const String titlePageResumen = 'Materias de Carrera';
  static const String route = '/materias_carrera_page';
  static const IconData icon = Icons.assignment_outlined;
  const MateriasCarreraPage({super.key});

  @override
  State<MateriasCarreraPage> createState() => _MateriasCarreraPageState();
}

class _MateriasCarreraPageState extends State<MateriasCarreraPage> {
  @override
  Widget build(BuildContext context) {
    return ListaMaterias(
      listMaterias: Constantes.materiasInformatica,
      icon: MateriasCarreraPage.icon,
      titulo: MateriasCarreraPage.titlePage,
      imagenFondo: Constantes.srcImgPortada1,
    );
  }
}
