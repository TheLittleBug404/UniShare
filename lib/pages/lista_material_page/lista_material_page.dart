import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uni_share/models/material_model/material_model.dart';
import 'package:uni_share/pages/visualizador_libro_page/visualizador_libro_page.dart';
import 'package:uni_share/services/database/database_material/database_material.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/widgets/custom_scroll_view_widget/custom_scrollview_widget.dart';

class ListaMaterialPage extends StatefulWidget {
  static const String titlePage = 'Material';
  static const String smallTitlePage = 'Material';
  static const String titlePageResumen = 'Material';
  static const String route = '/lista_material_page';
  static const IconData icon = Icons.upload_file;
  final String siglaMateria;
  final String nombreMateria;
  final String tipoMaterial;

  const ListaMaterialPage({
    super.key,
    required this.siglaMateria,
    required this.nombreMateria,
    required this.tipoMaterial,
  });

  @override
  State<ListaMaterialPage> createState() => _ListaMaterialPageState();
}

class _ListaMaterialPageState extends State<ListaMaterialPage> {
  List<Map<String, dynamic>> _material = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarMaterial();
  }

  // Método para obtener el icono según el tipo de material
  IconData _getIconoTipo() {
    switch (widget.tipoMaterial) {
      case 'libros':
        return Icons.menu_book;
      case 'codigos':
        return Icons.code;
      case 'practicas':
        return Icons.assignment;
      case 'enlaces':
        return Icons.link;
      case 'examenes':
        return Icons.quiz;
      default:
        return Icons.description;
    }
  }

  // Método para obtener el título según el tipo de material
  String _getTituloPagina() {
    switch (widget.tipoMaterial) {
      case 'libros':
        return 'Libros';
      case 'codigos':
        return 'Códigos';
      case 'practicas':
        return 'Prácticas';
      case 'enlaces':
        return 'Enlaces';
      case 'examenes':
        return 'Exámenes';
      default:
        return 'Material';
    }
  }

  // Método para obtener el color del icono según el tipo
  Color _getColorIcono() {
    switch (widget.tipoMaterial) {
      case 'libros':
        return Colors.blue;
      case 'codigos':
        return Colors.green;
      case 'practicas':
        return Colors.orange;
      case 'enlaces':
        return Colors.purple;
      case 'examenes':
        return Colors.red;
      default:
        return Utils.primaryColor;
    }
  }

  Future<void> _cargarMaterial() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Obtener el número de materia
      final numeroMateria = Constantes.obtenerNumeroMateria(
        widget.nombreMateria,
        widget.siglaMateria,
      );

      // Obtener y filtrar materiales
      final databaseMaterial = await DatabaseMaterial().readMaterial();

      final materialesFiltrados = databaseMaterial
          .where(
            (material) =>
                material.materia == numeroMateria &&
                _coincideConTipo(material.tipo, widget.tipoMaterial),
          )
          .map(_convertirMaterialAMap)
          .toList();

      setState(() {
        _material = materialesFiltrados;
        _isLoading = false;
      });

      if (materialesFiltrados.isEmpty) {
        Utils.showSnakbarInfo(
          "Sin materiales",
          "No hay materiales de tipo '${_getTituloPagina()}' para ${widget.nombreMateria}",
          3,
        );
      }
    } catch (e) {
      log("Error al cargar materiales: $e");
      setState(() {
        _isLoading = false;
        _material = [];
      });

      if (mounted) {
        Utils.showSnakbarError(
          "Error",
          "No se pudieron cargar los materiales: $e",
          4,
        );
      }
    }
  }

  // Método para verificar si el tipo de material coincide con el tipo seleccionado
  bool _coincideConTipo(String tipoMaterial, String tipoSeleccionado) {
    final Map<String, List<String>> mapeoTipos = {
      'libros': ['Libro', 'libro', 'book'],
      'codigos': ['Código', 'Codigo', 'código', 'codigo', 'code'],
      'practicas': ['Práctica', 'Practica', 'práctica', 'practica', 'practice'],
      'enlaces': ['Enlace', 'enlace', 'link', 'Link'],
      'examenes': ['Examen', 'examen', 'exam', 'test'],
    };

    final tiposValidos = mapeoTipos[tipoSeleccionado] ?? [tipoSeleccionado];
    return tiposValidos.any(
      (tipoValido) =>
          tipoMaterial.toLowerCase().contains(tipoValido.toLowerCase()),
    );
  }

  // Método simplificado para convertir el modelo Material a Map
  Map<String, dynamic> _convertirMaterialAMap(MaterialModel material) {
    return {
      'id': material.idMaterial.toString(),
      'nombre': material.descripcion, // Solo mostramos la descripción
      'url': material.enlaceDoc,
      'tipo': material.tipo,
    };
  }

  void _verMaterial(Map<String, dynamic> material) {
    if (widget.tipoMaterial == 'enlaces') {
      _mostrarDialogoEnlace(material);
    } else {
      _abrirVisualizadorArchivo(material);
    }
  }

  void _mostrarDialogoEnlace(Map<String, dynamic> material) {
    final String url = material['url'];
    final String nombre = material['nombre'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Utils.colorFondosSecundariosBordesSuaves,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.link, color: Utils.primaryColor, size: 24.0),
              const SizedBox(width: 8.0),
              Utils.estiloTexto(
                'Abrir Enlace',
                16.0,
                true,
                Utils.colorTextoBordesIconos,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.estiloTexto(
                nombre,
                14.0,
                true,
                Utils.colorTextoBordesIconos,
              ),
              const SizedBox(height: 8.0),
              Text(
                url,
                style: TextStyle(
                  color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
                  fontSize: 12.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            Utils.elevatedButton(
              "CANCELAR",
              Utils.colorTextoBordesIconos,
              () => Navigator.of(context).pop(),
            ),
            Utils.elevatedButton('ABRIR ENLACE', Utils.primaryColor, () {
              Navigator.of(context).pop();
              _abrirEnlaceExterno(url);
            }),
          ],
        );
      },
    );
  }

  void _abrirEnlaceExterno(String url) {
    try {
      Utils.launchInBrowser(url);
      Utils.showSnakbarInfo(
        "Enlace abierto",
        "Redirigiendo al navegador...",
        2,
      );
    } catch (e) {
      Utils.showSnakbarError("Error", "No se pudo abrir el enlace: $e", 4);
    }
  }

  void _abrirVisualizadorArchivo(Map<String, dynamic> material) {
    final String url = material['url'];
    final String nombre = material['nombre'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizadorLibroPage(
          urlLibro: url,
          nombreLibro: nombre,
          nombreMateria: widget.nombreMateria,
          siglaMateria: widget.siglaMateria,
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Utils.colorTextoBordesIconos,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Utils.colorTextoBordesIconos.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school, color: Utils.primaryColor, size: 20.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Utils.estiloTexto(
                  widget.nombreMateria,
                  16.0,
                  true,
                  Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.code, color: Utils.primaryColor, size: 16.0),
              const SizedBox(width: 8.0),
              Utils.estiloTexto(
                "Sigla: ${widget.siglaMateria}",
                14.0,
                false,
                Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Icon(_getIconoTipo(), color: Utils.primaryColor, size: 16.0),
              const SizedBox(width: 8.0),
              Utils.estiloTexto(
                "${_getTituloPagina()}: ${_material.length}",
                14.0,
                true,
                Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(Map<String, dynamic> material, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Utils.colorFondosSecundariosBordesSuaves.withValues(
              alpha: 0.2,
            ),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _verMaterial(material),
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Icono del item
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _getColorIcono().withValues(alpha: 0.3),
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _getIconoTipo(),
                          color: _getColorIcono(),
                          size: 24.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Información del material - SOLO LA DESCRIPCIÓN
                    Expanded(
                      child: Utils.estiloTexto(
                        material['nombre'],
                        14.0,
                        true,
                        Utils.colorTextoBordesIconos,
                      ),
                    ),
                    // Icono de flecha
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: _getColorIcono().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: _getColorIcono(),
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Image.asset('assets/img/logo_unishare.webp', width: 100, height: 100),
          Utils.loadingCustom(),
          const SizedBox(height: 10.0),
          Utils.estiloTexto(
            "Cargando materiales...",
            16.0,
            true,
            Utils.colorTextoBordesIconos,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              color: Utils.colorFondoPrincipal.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 60.0,
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20.0),
          Utils.estiloTexto(
            "No hay materials disponibles",
            18.0,
            true,
            Utils.colorTextoBordesIconos,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Utils.estiloTexto(
              "Actualmente no hay materials registrados para esta materia",
              14.0,
              false,
              Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
              true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollViewWidget(
      colorFondo: Utils.primaryColor,
      imagenFondo: Constantes.srcImgPortada1,
      titulo: _getTituloPagina(),
      silverList: SliverList(
        delegate: SliverChildListDelegate([
          const SizedBox(height: 10.0),
          _buildInfoCard(),
          const SizedBox(height: 20.0),
          if (_isLoading)
            _buildLoadingIndicator()
          else if (_material.isEmpty)
            _buildEmptyState()
          else
            ...List.generate(
              _material.length,
              (index) => _buildMaterialItem(_material[index], index),
            ),
          const SizedBox(height: 20.0),
        ]),
      ),
    );
  }
}
