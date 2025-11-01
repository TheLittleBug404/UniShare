import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static String route = '/main_page';
  static String title = 'Mis suministros';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Pagina MainPage'));
  }
}