import 'package:get/get.dart';

class LoginController extends GetxController {
    var auth = false.obs;
    var correo = "".obs;
    void setCorreo(String idSuc) {
        correo.value = idSuc;
    }

    String get getCorreo => correo.value;

    var fechaReserva = "".obs;
    void setFechaReserva(String fechaRes) {
        fechaReserva.value = fechaRes;
    }

    String get getFechaReserva => fechaReserva.value;

    //CAPTURAR EL ID, NOMBRE y PHOTO DE GOOGLE
    var idGoogle = "".obs;
    var photoGoogle = "".obs;
    var nameGoogle = "".obs;
    void setIdGoogle(String id) {
        idGoogle.value = id;
    }

    void setPhotoGoogle(String p) {
        photoGoogle.value = p;
    }

    void setNameGoogle(String n) {
        nameGoogle.value = n;
    }

    String get getIdGoogle => idGoogle.value;
    String get getPhotoGoogle => photoGoogle.value;
    String get getNameGoogle => nameGoogle.value;
    var horaReserva = "".obs;
    void setHoraReserva(String horaRes) {
        horaReserva.value = horaRes;
    }

    String get getHoraReserva => horaReserva.value;

    void setAuth(bool auth) {
        this.auth.value = auth;
    }

    bool get getAuth => auth.value;
}
