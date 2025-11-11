import 'package:flutter/material.dart';

class LibrosPage extends StatefulWidget {
  static const String titlePage = 'Manuales o Libros';
  static const String smallTitlePage = 'Manuales o Libros';
  static const String titlePageResumen = 'Manuales o Libros';
  static const String route = '/libros_page';
  static const IconData icon = Icons.book;
  const LibrosPage({super.key});

  @override
  State<LibrosPage> createState() => _LibrosPageState();
}

class _LibrosPageState extends State<LibrosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: const Text('LibrosPage'),),);
  }
}