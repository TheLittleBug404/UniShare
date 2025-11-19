import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/material_controller/material_controller.dart';
import 'package:uni_share/controllers/navigation_controller/navigation_controller.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:uni_share/widgets/custom_scroll_view_widget/custom_scrollview_widget.dart';

class ListaMaterias extends StatefulWidget {
  final List<Map<String, String>> listMaterias;
  final IconData icon;
  final String titulo;
  final String imagenFondo;
  const ListaMaterias({
    super.key,
    required this.listMaterias,
    required this.icon,
    required this.titulo,
    required this.imagenFondo,
  });
  @override
  ListaMateriasState createState() => ListaMateriasState();
}

class ListaMateriasState extends State<ListaMaterias> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _materiasFiltradas = [];
  bool _mostrarTodas = true;

  @override
  void initState() {
    super.initState();
    _verifyInternetConnection();
    // Inicializar con todas las materias
    _materiasFiltradas = List.from(widget.listMaterias);
    _searchController.addListener(_filtrarMaterias);
  }

  Future<void> _verifyInternetConnection() async {
    bool hasInternet = await Utils.hasInternet();
    if (mounted) {
      if (!hasInternet) {
        Utils.showSnakbarSinInternet(
          "Sin conexión",
          "Revise su conexión a internet",
          4,
        );
      }
      setState(() {
        hasInternet = hasInternet;
      });
    }
  }

  void _filtrarMaterias() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // Si no hay texto, mostrar todas las materias
        _materiasFiltradas = List.from(widget.listMaterias);
        _mostrarTodas = true;
      } else {
        // Normalizar la consulta: quitar guiones, espacios y convertir a minúsculas
        final queryNormalizada = _normalizarTexto(query);

        // Filtrar materias por nombre o sigla normalizada
        _materiasFiltradas = widget.listMaterias.where((materia) {
          final nombre = materia['nombre']?.toLowerCase() ?? '';
          final sigla = materia['sigla']?.toLowerCase() ?? '';

          // Normalizar los textos para comparación
          final nombreNormalizado = _normalizarTexto(nombre);
          final siglaNormalizada = _normalizarTexto(sigla);

          // Buscar en nombre o sigla normalizada
          return nombreNormalizado.contains(queryNormalizada) ||
              siglaNormalizada.contains(queryNormalizada);
        }).toList();
        _mostrarTodas = false;
      }
    });
  }

  // Método auxiliar para normalizar texto (quitar guiones, espacios, etc.)
  String _normalizarTexto(String texto) {
    return texto
        .replaceAll('-', '') // Quitar guiones
        .replaceAll(' ', '') // Quitar espacios
        .toLowerCase(); // Convertir a minúsculas
  }

  void _buscarMateria() {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      Utils.showSnakbarInfo(
        "Búsqueda vacía",
        "Ingrese un nombre o sigla de materia",
        3,
      );
      return;
    }

    _filtrarMaterias();
    Utils.ocultarTeclado(context);

    // Mostrar mensaje si no se encontraron resultados
    if (_materiasFiltradas.isEmpty) {
      Utils.showSnakbarInfo(
        "No se encontraron resultados",
        "No hay materias que coincidan con '$query'",
        4,
      );
    } else {
      final queryNormalizada = _normalizarTexto(query);
      Utils.showSnakbarInfo(
        "Búsqueda exitosa",
        "Se encontraron ${_materiasFiltradas.length} materia(s) para '$queryNormalizada'",
        3,
      );
    }
  }

  void _limpiarBusqueda() {
    _searchController.clear();
    setState(() {
      _materiasFiltradas = List.from(widget.listMaterias);
      _mostrarTodas = true;
    });
    Utils.ocultarTeclado(context);
  }

  @override
  Widget build(BuildContext context) {
    return _body(_materiasFiltradas);
  }

  _body(List<Map<String, String>> vList) {
    return CustomScrollViewWidget(
      colorFondo: Utils.primaryColor,
      imagenFondo: widget.imagenFondo,
      titulo: widget.titulo,
      silverList: SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Utils.estiloTexto(
                        "Búsqueda de materias",
                        12.0,
                        true,
                        null,
                        true,
                      ),
                    ),
                    Utils.iconButton(Utils.primaryColor, () {
                      Utils.showAwesomeDialog(
                        "Busque la materia por sigla o nombre",
                        Text(
                          'Puede buscar materias por:\n• Nombre (ej: "Programacion")\n• Sigla (ej: "INF-111", "inf 111", "inf111")',
                        ),
                      );
                    }, Icons.help),
                  ],
                ),
                Utils.espacio10,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _formBuscador(),
                ),
                Utils.espacio10,
                // Mostrar información de resultados
                if (!_mostrarTodas)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utils.estiloTexto(
                          "Resultados: ${_materiasFiltradas.length} materia(s)",
                          12.0,
                          true,
                          Utils.colorTextoBordesIconos,
                        ),
                        TextButton(
                          onPressed: _limpiarBusqueda,
                          child: Row(
                            children: [
                              Icon(Icons.clear, size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Utils.estiloTexto(
                                "Limpiar",
                                12.0,
                                true,
                                Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Lista de materias
          if (_materiasFiltradas.isNotEmpty)
            ...List.generate(
              _materiasFiltradas.length,
              (index) => Card(
                elevation: 5.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                child: Container(
                  decoration: Utils.boxDecoraton(),
                  child: _makeListTile(_materiasFiltradas, index),
                ),
              ),
            )
          else if (!_mostrarTodas)
            // Mensaje cuando no hay resultados
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Utils.estiloTexto(
                    "No se encontraron materias",
                    16.0,
                    true,
                    Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Utils.estiloTexto(
                    "Intente con otros términos de búsqueda",
                    14.0,
                    false,
                    Colors.grey.shade500,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _limpiarBusqueda,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Utils.primaryColor,
                    ),
                    child: const Text("Mostrar todas las materias"),
                  ),
                ],
              ),
            ),
        ]),
      ),
    );
  }

  _formBuscador() {
    return Table(
      children: <TableRow>[
        TableRow(
          children: [
            Container(
              child: _inputTextBuscador("Buscar por nombre o sigla..."),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                style: Utils.estiloBotonBordeColor(Utils.estiloShapeAzul()),
                onPressed: _buscarMateria,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 38.0,
                        color: Utils.colorTextoBordesIconos,
                      ),
                      Utils.estiloTexto(
                        "Buscar",
                        14.0,
                        true,
                        Utils.colorTextoBordesIconos,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _makeListTile(List<Map<String, String>> vList, int i) {
    String titulo = vList[i]['nombre']!;
    String sigla = vList[i]['sigla']!;
    String semestre = vList[i]['semestre']!;
    Icon icono = Icon(widget.icon, color: Utils.primaryColor, size: 30.0);

    return CustomExpansionTile(
      iconLeading: icono,
      title: Utils.estiloTexto(
        titulo,
        13.0,
        true,
        Utils.colorTextoBordesIconos,
      ),
      subtitle: Text(sigla),
      backgroundColor: Utils.primaryColor2,
      children2: [
        ListTile(
          title: Text("Sigla: $sigla"),
          subtitle: Text("Semestre: $semestre"),
          leading: Icon(Icons.book, color: Colors.blue),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            log("Tocaste el list View");
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Utils.colorFondosSecundariosBordesSuaves,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Utils.colorFondosSecundariosBordesSuaves,
              ),
            ),
            child: Center(
              child: BotonesMaterias(
                sigla: sigla, 
                nombre: titulo, 
                )
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputTextBuscador(String label) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _searchController,
      style: TextStyle(
        color: Utils.primaryColor,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
        labelStyle: TextStyle(
          fontSize: 14.0,
          color: Utils.colorTextoBordesIconos,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Utils.colorTextoBordesIconos,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Utils.colorTextoBordesIconos,
            width: 2.0,
          ),
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Utils.colorTextoBordesIconos),
                onPressed: () {
                  _searchController.clear();
                  _filtrarMaterias();
                },
              )
            : null,
      ),
      onFieldSubmitted: (value) {
        _buscarMateria();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class BotonesMaterias extends StatelessWidget {
  final String sigla;
  final String nombre;
  const BotonesMaterias({
    super.key,
    required this.sigla,
    required this.nombre,
  });

  void _verMaterial(BuildContext context,String sigla,String nombre,String tipo) {
    final nc = Get.find<NavigationController>();
    final mc = Get.find<MaterialController>();
    mc.setSigla(sigla);
    mc.setNombre(nombre);
    mc.setTipo(tipo);
    nc.setIndexPage(5);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Utils.elevatedButton(
                'Ver Codigo',
                Utils.colorTextoBordesIconos,
                () => _verMaterial(context, sigla, nombre,'Código'),
              ),
              Utils.elevatedButton(
                'Ver Libros',
                Utils.colorTextoBordesIconos,
                () => _verMaterial(context, sigla, nombre,'Libro'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Utils.elevatedButton(
                'Ver Praticas',
                Utils.colorTextoBordesIconos,
                () => _verMaterial(context, sigla, nombre,'Práctica'),
              ),
              Utils.elevatedButton(
                'Ver Enlaces',
                Utils.colorTextoBordesIconos,
                () => _verMaterial(context, sigla, nombre,'Enlace'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Utils.elevatedButton(
                'Ver Examenes pasados',
                Utils.colorTextoBordesIconos,
                () => _verMaterial(context, sigla, nombre,'Examen'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
