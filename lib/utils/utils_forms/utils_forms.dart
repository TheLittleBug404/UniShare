class UtilsForms {
  static String patternEmail() =>
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static String patternNumber() => r'^\+{1}\d{10,17}';
  static String patternText() => r'(^[a-zA-Z ]*$)';

  static List<Map<String, String>> tiposDocumento = [
    {
      "titulo": "Cédula de identidad",
      "valor": "1",
    },
    {
      "titulo": "Cédula extranjera",
      "valor": "2",
    }
  ];
  static List<Map<String, String>> extensiones = [
    {
      "titulo": "La Paz",
      "valor": "lp",
    },
    {
      "titulo": "Oruro",
      "valor": "or",
    },
    {
      "titulo": "Potosí",
      "valor": "pt",
    },
    {"titulo": "Cochabamba", "valor": "cb"},
    {"titulo": "Santa Cruz", "valor": "sc"},
    {"titulo": "Beni", "valor": "be"},
    {"titulo": "Pando", "valor": "pd"},
    {"titulo": "Tarija", "valor": "tj"},
    {"titulo": "Chuquisaca", "valor": "ch"},
    {"titulo": "Exterior", "valor": "E"}
  ];
}
