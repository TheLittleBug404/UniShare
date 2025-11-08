import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/pages/home_page/home_page.dart';
import 'package:uni_share/utils/utils/utils.dart';

class DasboardPage extends StatefulWidget {
  static const String titlePage = 'Dashboard';
  static const String route = '/dashboard_page';
  static const IconData icon = Icons.person;
  const DasboardPage({super.key});

  @override
  State<DasboardPage> createState() => _DasboardPageState();
}

class _DasboardPageState extends State<DasboardPage> {
  final loadingC = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: (){
              loadingC.setOnLoading();
              try {
                supabase.auth.signOut();
                Get.to(HomePage(), duration: Duration(milliseconds: 500));
                Utils.showSnakbarOK(
                  "Exito", 
                  "Se cerro la sesion con exito ", 
                  4
                );
              } catch (e) {
                Utils.showSnakbarError(
                  "Error",
                  "Paso algo en el proceso intentelo mas tarde",
                  4,
                );
              } finally {
                loadingC.setOffLoading();
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: const Text('Pagina dashboard')),
    );
  }
}
