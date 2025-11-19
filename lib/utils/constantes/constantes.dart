class Constantes {
  static String title = 'UniShare';
  static String versAppAndroid = '0.1.0';
  static String versAppApple = '0.1.0';
  static const String attribApp = "UniShare";
  static const String clavePublicaSupabase =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2YmNxcHZldnZzc3J4aGxkZmJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIwNDg0MTEsImV4cCI6MjA3NzYyNDQxMX0.8HkQjxtiwKPH-8lC0JO9VDL4Ozy4Q7DRV1PgMGtd69k';

  static const String srcImgPortada1 = "assets/img/imagen1.webp";

  //lista de materias de carrera
  static final materiasInformatica = [
    {
      "nombre": "Programacion I",
      "sigla": "INF - 111",
      "semestre": "Primer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Fundamentos Digitales",
      "sigla": "INF - 112",
      "semestre": "Primer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion Web",
      "sigla": "INF - 113",
      "semestre": "Primer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion II",
      "sigla": "INF - 121",
      "semestre": "Segundo semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion Web II",
      "sigla": "INF - 122",
      "semestre": "Segundo semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion III",
      "sigla": "INF - 131",
      "semestre": "Tercer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Base de datos I",
      "sigla": "INF - 132",
      "semestre": "Tercer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion Web III",
      "sigla": "INF - 133",
      "semestre": "Tercer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Sistemas Operativos",
      "sigla": "INF - 135",
      "semestre": "Tercer semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Analisis y diseño de sistemas I",
      "sigla": "INF - 241",
      "semestre": "Cuarto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Redes I",
      "sigla": "INF - 242",
      "semestre": "Cuarto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Introduccion a la Robotica",
      "sigla": "INF - 244",
      "semestre": "Cuarto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion de dispositivos moviles I",
      "sigla": "INF - 245",
      "semestre": "Cuarto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Fundamentos y diseño de animación",
      "sigla": "INF - 246",
      "semestre": "Cuarto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Programacion de dispositivos moviles II",
      "sigla": "INF - 251",
      "semestre": "Quinto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Base de datos II",
      "sigla": "INF - 252",
      "semestre": "Quinto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Analisis y diseño de sistemas",
      "sigla": "INF - 253",
      "semestre": "Quinto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Ingenieria de Software",
      "sigla": "INF - 254",
      "semestre": "Quinto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Base de datos III",
      "sigla": "INF - 261",
      "semestre": "Sexto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Ingenieria de Software II",
      "sigla": "INF - 262",
      "semestre": "Sexto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Desarrollo de aplicaciones multimedia",
      "sigla": "INF - 263",
      "semestre": "Sexto semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Inteligencia Artificial",
      "sigla": "INF - 372",
      "semestre": "Septimo semestre",
      "icon": "access_time",
    },
    {
      "nombre": "Ingenieria de Software III",
      "sigla": "INF - 382",
      "semestre": "Octavo semestre",
      "icon": "access_time",
    },
  ];
  // Método para obtener el número de materia basado en nombre y sigla
  static int obtenerNumeroMateria(String nombreMateria, String siglaMateria) {
    final Map<String, int> mapeoMaterias = {
      'Programacion I': 2,
      'Fundamentos Digitales': 3,
      'Programacion Web': 4,
      'Programacion II': 5,
      'Programacion Web II': 6,
      'Programacion III': 7,
      'Base de datos I': 8,
      'Programacion Web III': 9,
      'Sistemas Operativos': 10,
      'Analisis y diseño de sistemas I': 11,
      'Redes I': 12,
      'Introduccion a la Robotica': 13,
      'Programacion de dispositivos moviles I': 14,
      'Fundamentos y diseño de animación': 15,
      'Programacion de dispositivos moviles II': 16,
      'Base de datos II': 17,
      'Analisis y diseño de sistemas': 18,
      'Ingenieria de Software': 19,
      'Base de datos III': 20,
      'Ingenieria de Software II': 21,
      'Desarrollo de aplicaciones multimedia': 22,
      'Inteligencia Artificial': 23,
      'Ingenieria de Software III': 24,
    };

    // Buscar por nombre exacto
    if (mapeoMaterias.containsKey(nombreMateria)) {
      return mapeoMaterias[nombreMateria]!;
    }

    // Si no encuentra por nombre, buscar por sigla
    final mapeoSiglas = {
      'INF - 111': 2,
      'INF - 112': 3,
      'INF - 113': 4,
      'INF - 121': 5,
      'INF - 122': 6,
      'INF - 131': 7,
      'INF - 132': 8,
      'INF - 133': 9,
      'INF - 135': 10,
      'INF - 241': 11,
      'INF - 242': 12,
      'INF - 244': 13,
      'INF - 245': 14,
      'INF - 246': 15,
      'INF - 251': 16,
      'INF - 252': 17,
      'INF - 253': 18,
      'INF - 254': 19,
      'INF - 261': 20,
      'INF - 262': 21,
      'INF - 263': 22,
      'INF - 372': 23,
      'INF - 382': 24,
    };

    if (mapeoSiglas.containsKey(siglaMateria)) {
      return mapeoSiglas[siglaMateria]!;
    }

    throw Exception(
      "No se encontró el número para la materia: $nombreMateria ($siglaMateria)",
    );
  }
}
