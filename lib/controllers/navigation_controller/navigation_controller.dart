import 'package:get/get.dart';

class NavigationController extends GetxController {
  var indexPage = 0.obs;

  void setIndexPage(int ip) => indexPage.value = ip;
  int get getIndexPage => indexPage.value;
}
