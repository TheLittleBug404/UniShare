import 'package:get/get.dart';

class MaterialController extends GetxController{
  RxString sigla = "".obs;
  RxString nombre = "".obs;
  RxString tipo = "".obs;

  String get getSigla => sigla.value;
  String get getNombre => nombre.value;
  String get getTipo => tipo.value;

  void setSigla(String c) => sigla.value = c;
  void setNombre(String c) => nombre.value = c;
  void setTipo(String c) => tipo.value = c;
}