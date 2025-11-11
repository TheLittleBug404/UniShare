import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/widgets/custom_scroll_view_widget/custom_scrollview_widget.dart';

class SubirMaterialPage extends StatefulWidget {
  static const String titlePage = 'Subir material';
  static const String smallTitlePage = 'Subir material';
  static const String titlePageResumen = 'subir material';
  static const String route = '/subir_material_page';
  static const IconData icon = Icons.upload_file;

  const SubirMaterialPage({super.key});

  @override
  SubirMaterialPageState createState() => SubirMaterialPageState();
}

class SubirMaterialPageState extends State<SubirMaterialPage> {
  // Controladores para los campos del formulario
  TextEditingController descripcionController = TextEditingController();
  TextEditingController enlaceController = TextEditingController();

  final loadingC = Get.find<LoadingController>();

  // Variables para selección
  String? _siglaSeleccionada;
  String? _nombreMateriaSeleccionado;
  String _tipoMaterialSeleccionado = 'Código';
  String _semestreSeleccionado = 'Primer semestre';

  // Listas para dropdowns
  final List<String> _tiposMaterial = [
    'Código',
    'Libro',
    'Práctica',
    'Enlace',
    'Examen',
  ];

  // Mapa para ordenar semestres numéricamente
  final Map<String, int> _ordenSemestres = {
    'Primer semestre': 1,
    'Segundo semestre': 2,
    'Tercer semestre': 3,
    'Cuarto semestre': 4,
    'Quinto semestre': 5,
    'Sexto semestre': 6,
    'Séptimo semestre': 7,
    'Octavo semestre': 8,
    'Noveno semestre': 9,
  };

  // Obtener lista única de semestres desde Constantes ORDENADOS
  List<String> get _semestres {
    final semestres = Constantes.materiasInformatica
        .map((materia) => materia['semestre']!)
        .toSet()
        .toList();

    // Ordenar semestres numéricamente
    semestres.sort((a, b) {
      final ordenA = _ordenSemestres[a] ?? 999;
      final ordenB = _ordenSemestres[b] ?? 999;
      return ordenA.compareTo(ordenB);
    });

    return semestres;
  }

  // Obtener materias filtradas por semestre
  List<Map<String, String>> get _materiasPorSemestre {
    if (_semestreSeleccionado.isEmpty) {
      return Constantes.materiasInformatica;
    }
    return Constantes.materiasInformatica
        .where((materia) => materia['semestre'] == _semestreSeleccionado)
        .toList();
  }

  // Obtener siglas únicas para el semestre seleccionado ORDENADAS
  List<String> get _siglasPorSemestre {
    final siglas = _materiasPorSemestre
        .map((materia) => materia['sigla']!)
        .toSet()
        .toList();

    // Ordenar siglas numéricamente
    siglas.sort((a, b) {
      // Extraer números de las siglas (ej: "INF - 111" -> 111)
      final numeroA = _extraerNumeroSigla(a);
      final numeroB = _extraerNumeroSigla(b);
      return numeroA.compareTo(numeroB);
    });

    return siglas;
  }

  // Obtener nombres únicos para el semestre seleccionado ORDENADOS
  List<String> get _nombresPorSemestre {
    final nombres = _materiasPorSemestre
        .map((materia) => materia['nombre']!)
        .toSet()
        .toList();

    // Ordenar nombres alfabéticamente
    nombres.sort((a, b) => a.compareTo(b));

    return nombres;
  }

  // Método para extraer el número de una sigla
  int _extraerNumeroSigla(String sigla) {
    try {
      // Buscar números en la sigla (ej: "INF - 111" -> 111)
      final regex = RegExp(r'(\d+)');
      final match = regex.firstMatch(sigla);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
      return 999; // Valor alto para siglas sin número
    } catch (e) {
      return 999;
    }
  }

  @override
  void initState() {
    super.initState();
    // Establecer valores iniciales
    _semestreSeleccionado = _semestres.isNotEmpty ? _semestres.first : '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        progressIndicator: Utils.loadingCustom(),
        color: Colors.white.withValues(alpha: 0.6),
        isLoading: loadingC.getLoading,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return CustomScrollViewWidget(
      colorFondo: Utils.primaryColor,
      imagenFondo: Constantes.srcImgPortada1,
      titulo: SubirMaterialPage.titlePage,
      silverList: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return _subBody();
        }, childCount: 1),
      ),
    );
  }

  _subBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Utils.espacio10,
          _tituloSeccion("DATOS DE LA MATERIA"),
          Utils.espacio20,
          _formularioMaterial(),
          Utils.espacio30,
          _botonesSubirMaterial(),
          Utils.espacio50,
        ],
      ),
    );
  }

  Widget _tituloSeccion(String titulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Utils.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Utils.colorTextoBordesIconos.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        titulo,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _formularioMaterial() {
    return Column(
      children: [
        // Fila 1: Semestre y Tipo de material
        Row(
          children: [
            Expanded(
              child: _dropdownFormulario(
                "Semestre*",
                _semestreSeleccionado,
                _semestres,
                Icons.date_range,
                (String? nuevoValor) {
                  setState(() {
                    _semestreSeleccionado = nuevoValor!;
                    log("Semestre seleccionado :::> $_semestreSeleccionado");
                    // Limpiar selecciones de materia al cambiar semestre
                    _siglaSeleccionada = null;
                    _nombreMateriaSeleccionado = null;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _dropdownFormulario(
                "Tipo de material*",
                _tipoMaterialSeleccionado,
                _tiposMaterial,
                Icons.category,
                (String? nuevoValor) {
                  setState(() {
                    _tipoMaterialSeleccionado = nuevoValor!;
                  });
                },
              ),
            ),
          ],
        ),
        Utils.espacio15,

        // Fila 2: Sigla de la materia
        _dropdownFormulario(
          "Sigla de la materia*",
          _siglaSeleccionada,
          _siglasPorSemestre,
          Icons.class_,
          (String? nuevaSigla) {
            setState(() {
              _siglaSeleccionada = nuevaSigla;
              if (nuevaSigla != null) {
                // Encontrar y sincronizar el nombre de la materia
                final materia = _materiasPorSemestre.firstWhere(
                  (m) => m['sigla'] == nuevaSigla,
                );
                _nombreMateriaSeleccionado = materia['nombre'];
              }
            });
          },
        ),
        Utils.espacio15,

        // Fila 3: Nombre de la materia
        _dropdownFormulario(
          "Nombre de la materia*",
          _nombreMateriaSeleccionado,
          _nombresPorSemestre,
          Icons.school,
          (String? nuevoNombre) {
            setState(() {
              _nombreMateriaSeleccionado = nuevoNombre;
              if (nuevoNombre != null) {
                // Encontrar y sincronizar la sigla
                final materia = _materiasPorSemestre.firstWhere(
                  (m) => m['nombre'] == nuevoNombre,
                );
                _siglaSeleccionada = materia['sigla'];
              }
            });
          },
        ),
        Utils.espacio15,

        // Información de la materia seleccionada
        if (_siglaSeleccionada != null && _nombreMateriaSeleccionado != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Utils.primaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$_siglaSeleccionada - $_nombreMateriaSeleccionado",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Utils.espacio15,

        // Descripción del material
        _campoFormularioGrande(
          "Descripción del material*",
          "Describe brevemente el contenido del material...",
          descripcionController,
          Icons.description,
          TextInputType.multiline,
          4,
        ),
        Utils.espacio15,

        // Enlace o archivo (condicional)
        if (_tipoMaterialSeleccionado == 'Enlace')
          _campoFormulario(
            "Enlace URL*",
            "https://ejemplo.com/material",
            enlaceController,
            Icons.link,
            TextInputType.url,
          )
        else
          _seleccionarArchivo(),
      ],
    );
  }

  Widget _campoFormulario(
    String label,
    String hint,
    TextEditingController controller,
    IconData icono,
    TextInputType tipoTeclado, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Utils.colorTextoBordesIconos,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.4),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: tipoTeclado,
            maxLines: maxLines,
            style: TextStyle(color: Utils.colorTextoBordesIconos, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                icono,
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _campoFormularioGrande(
    String label,
    String hint,
    TextEditingController controller,
    IconData icono,
    TextInputType tipoTeclado,
    int maxLines,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Utils.colorTextoBordesIconos,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.4),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: tipoTeclado,
            maxLines: maxLines,
            style: TextStyle(color: Utils.colorTextoBordesIconos, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                icono,
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownFormulario(
    String label,
    String? valorActual,
    List<String> opciones,
    IconData icono,
    Function(String?) onChanged,
  ) {
    // Texto a mostrar cuando no hay selección
    final textoMostrar = valorActual ?? "Seleccione una opción";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Utils.colorTextoBordesIconos,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: valorActual,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Utils.colorTextoBordesIconos,
              ),
              isExpanded: true,
              underline: const SizedBox(),
              style: TextStyle(
                color: Utils.colorTextoBordesIconos,
                fontSize: 14,
              ),
              hint: Row(
                children: [
                  Icon(
                    icono,
                    size: 18,
                    color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(textoMostrar),
                ],
              ),
              onChanged: onChanged,
              items: opciones.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(
                        icono,
                        size: 18,
                        color: Utils.colorTextoBordesIconos.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarArchivo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subir archivo*",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Utils.colorTextoBordesIconos,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _seleccionarArchivoDialog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Utils.colorFondoSecundario(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Utils.colorTextoBordesIconos.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: Colors
                      .white, //Utils.colorTextoBordesIconos.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                Text(
                  "Toca para seleccionar un archivo",
                  style: TextStyle(
                    color: Colors.white, //Utils.colorTextoBordesIconos,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _seleccionarArchivoDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: Get.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Utils.colorPrimario(1.0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Utils.colorFondoSecundario(1.0),
                Utils.colorFondoSecundario(0.9),
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header con icono decorativo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo de fondo decorativo
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    // Icono principal
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Utils.colorTextoBordesIconos,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Título principal
                Text(
                  "Seleccionar Archivo",
                  style: TextStyle(
                    color: Utils.colorTextoBordesIconos,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtítulo
                Text(
                  "Elige el archivo que deseas subir",
                  style: TextStyle(
                    color: Utils.colorTextoBordesIconos.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Información de formatos soportados
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Utils.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Utils.colorPrimario(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.info,
                        "Formatos soportados:",
                        isBold: true,
                      ),
                      const SizedBox(height: 8),
                      _buildFormatItem("PDF", "Documentos"),
                      _buildFormatItem("Enlaces", "Tutoriales"),
                      _buildFormatItem("DOC, DOCX", "Documentos Word"),
                      _buildFormatItem("PPT, PPTX", "Presentaciones"),
                      _buildFormatItem("TXT", "Archivos de texto"),
                      _buildFormatItem("Practicas", "Apuntes"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Opciones de selección
                Column(
                  children: [
                    // Botón para galería de archivos
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _abrirExploradorArchivos();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Utils.colorTextoBordesIconos,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Abrir Explorador de Archivos',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botón para tomar foto (opcional)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _tomarFotoDocumento();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Utils.colorTextoBordesIconos,
                          side: BorderSide(color: Utils.colorTextoBordesIconos),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Tomar Foto del Documento',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Utils.colorTextoBordesIconos,
                          side: BorderSide(color: Utils.colorTextoBordesIconos),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _simularSeleccionArchivo();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Utils.colorTextoBordesIconos,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Seleccionar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método auxiliar para construir items de formato
  Widget _buildFormatItem(String formato, String descripcion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Utils.colorTextoBordesIconos,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$formato - $descripcion",
              style: TextStyle(
                color: Utils.colorTextoBordesIconos,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para construir filas de información
  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, color: Utils.colorTextoBordesIconos, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Utils.colorTextoBordesIconos,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  // Métodos de simulación (los puedes reemplazar con la lógica real)
  void _abrirExploradorArchivos() {
    // Aquí integrarías file_picker para seleccionar archivos
    Utils.showSnakbarInfo(
      "Explorador de archivos",
      "Aquí se abriría el selector de archivos del dispositivo",
      3,
    );
  }

  void _tomarFotoDocumento() {
    // Aquí integrarías la cámara para tomar fotos de documentos
    Utils.showSnakbarInfo(
      "Cámara",
      "Aquí se abriría la cámara para tomar foto del documento",
      3,
    );
  }

  void _simularSeleccionArchivo() {
    // Simulación de selección de archivo
    Utils.showSnakbarInfo(
      "Archivo seleccionado",
      "archivo_ejemplo.pdf ha sido seleccionado",
      3,
    );
  }

  _botonesSubirMaterial() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Utils.colorTextoBordesIconos,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _validarYSubirMaterial,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "SUBIR MATERIAL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Utils.colorTextoBordesIconos,
              side: BorderSide(color: Utils.colorTextoBordesIconos),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _limpiarFormulario,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.clear, color: Utils.colorTextoBordesIconos),
                const SizedBox(width: 8),
                Text(
                  "LIMPIAR FORMULARIO",
                  style: TextStyle(
                    color: Utils.colorTextoBordesIconos,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _validarYSubirMaterial() {
    Utils.ocultarTeclado(context);

    if (_siglaSeleccionada == null) {
      Utils.showSnakbarError(
        "Error",
        "La sigla de la materia es obligatoria",
        3,
      );
      return;
    }

    if (_nombreMateriaSeleccionado == null) {
      Utils.showSnakbarError(
        "Error",
        "El nombre de la materia es obligatorio",
        3,
      );
      return;
    }

    if (descripcionController.text.isEmpty) {
      Utils.showSnakbarError(
        "Error",
        "La descripción del material es obligatoria",
        3,
      );
      return;
    }

    if (_tipoMaterialSeleccionado == 'Enlace' &&
        enlaceController.text.isEmpty) {
      Utils.showSnakbarError(
        "Error",
        "El enlace es obligatorio para material tipo 'Enlace'",
        3,
      );
      return;
    }

    // Mostrar diálogo de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Utils.colorPrimario(1.0),
        title: Text(
          "Confirmar subida",
          style: TextStyle(
            color: Utils.colorTextoBordesIconos,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "¿Está seguro de subir el siguiente material?",
                style: TextStyle(color: Utils.colorTextoBordesIconos),
              ),
              const SizedBox(height: 16),
              _itemConfirmacion(
                "Materia:",
                "$_siglaSeleccionada - $_nombreMateriaSeleccionado",
              ),
              _itemConfirmacion("Semestre:", _semestreSeleccionado),
              _itemConfirmacion("Tipo:", _tipoMaterialSeleccionado),
              _itemConfirmacion("Descripción:", descripcionController.text),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(color: Utils.colorTextoBordesIconos),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Utils.colorTextoBordesIconos,
            ),
            onPressed: () async {
              Navigator.pop(context);
              loadingC.setOnLoading();

              // Simular subida de material
              await Future.delayed(const Duration(seconds: 2));

              loadingC.setOffLoading();
              Utils.showSnakbarOK(
                "¡Material subido exitosamente!",
                "El material ha sido compartido con la comunidad",
                4,
              );
              _limpiarFormulario();
            },
            child: const Text(
              "Confirmar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemConfirmacion(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Utils.colorTextoBordesIconos,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(color: Utils.colorTextoBordesIconos),
            ),
          ),
        ],
      ),
    );
  }

  void _limpiarFormulario() {
    setState(() {
      _siglaSeleccionada = null;
      _nombreMateriaSeleccionado = null;
      _tipoMaterialSeleccionado = 'Código';
      _semestreSeleccionado = _semestres.isNotEmpty ? _semestres.first : '';
      descripcionController.clear();
      enlaceController.clear();
    });
    Utils.showSnakbarInfo(
      "Formulario limpiado",
      "Todos los campos han sido reseteados",
      2,
    );
  }

  @override
  void dispose() {
    descripcionController.dispose();
    enlaceController.dispose();
    super.dispose();
  }
}
