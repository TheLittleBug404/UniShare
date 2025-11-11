import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/controllers/login_controller/login_controller.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:uni_share/widgets/custom_scroll_view_widget/custom_scrollview_widget.dart';

class NotificacionesPage extends StatefulWidget {
  static const String titlePage = 'Notificaciones';
  static const String smallTitlePage = 'Notificaciones';
  static const String titlePageResumen = 'Notificaciones';
  static const String route = '/notificaciones_page';
  static const IconData icon = Icons.notifications;

  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  final lc = Get.find<LoginController>();
  final loadingC = Get.find<LoadingController>();

  // Lista de notificaciones de ejemplo
  final List<Map<String, dynamic>> _notificaciones = [
    {
      'id': 1,
      'titulo': 'Nuevo libro subido',
      'descripcion': 'Se ha subido el libro "Programación I - Guía Completa"',
      'materia': 'Programacion I',
      'sigla': 'INF - 111',
      'semestre': 'Primer semestre',
      'tipo': 'Libro',
      'fecha': 'Hace 2 horas',
      'leido': false,
      'icono': Icons.book,
    },
    {
      'id': 2,
      'titulo': 'Práctica disponible',
      'descripcion': 'Nueva práctica de laboratorio para Base de Datos I',
      'materia': 'Base de datos I',
      'sigla': 'INF - 132',
      'semestre': 'Tercer semestre',
      'tipo': 'Práctica',
      'fecha': 'Hace 5 horas',
      'leido': false,
      'icono': Icons.assignment,
    },
    {
      'id': 3,
      'titulo': 'Enlace de tutorial',
      'descripcion': 'Tutorial completo de Programación Web III - React.js',
      'materia': 'Programacion Web III',
      'sigla': 'INF - 133',
      'semestre': 'Tercer semestre',
      'tipo': 'Enlace',
      'fecha': 'Ayer',
      'leido': true,
      'icono': Icons.link,
    },
    {
      'id': 4,
      'titulo': 'Código fuente',
      'descripcion':
          'Repositorio con ejemplos de Programación de Dispositivos Móviles',
      'materia': 'Programacion de dispositivos moviles I',
      'sigla': 'INF - 245',
      'semestre': 'Cuarto semestre',
      'tipo': 'Código',
      'fecha': 'Ayer',
      'leido': true,
      'icono': Icons.code,
    },
    {
      'id': 5,
      'titulo': 'Examen resuelto',
      'descripcion':
          'Solucionario del primer parcial de Inteligencia Artificial',
      'materia': 'Inteligencia Artificial',
      'sigla': 'INF - 372',
      'semestre': 'Séptimo semestre',
      'tipo': 'Examen',
      'fecha': 'Hace 2 días',
      'leido': true,
      'icono': Icons.quiz,
    },
    {
      'id': 6,
      'titulo': 'Presentación actualizada',
      'descripcion': 'Diapositivas actualizadas de Ingeniería de Software II',
      'materia': 'Ingenieria de Software II',
      'sigla': 'INF - 262',
      'semestre': 'Sexto semestre',
      'tipo': 'Presentación',
      'fecha': 'Hace 3 días',
      'leido': true,
      'icono': Icons.slideshow,
    },
    {
      'id': 7,
      'titulo': 'Libro recomendado',
      'descripcion': 'Nuevo libro sobre Redes I - Cisco CCNA',
      'materia': 'Redes I',
      'sigla': 'INF - 242',
      'semestre': 'Cuarto semestre',
      'tipo': 'Libro',
      'fecha': 'Hace 4 días',
      'leido': true,
      'icono': Icons.book,
    },
  ];

  // Agrupar notificaciones por semestre
  Map<String, List<Map<String, dynamic>>> get _notificacionesPorSemestre {
    final Map<String, List<Map<String, dynamic>>> agrupadas = {};

    for (var notificacion in _notificaciones) {
      final semestre = notificacion['semestre'];
      if (!agrupadas.containsKey(semestre)) {
        agrupadas[semestre] = [];
      }
      agrupadas[semestre]!.add(notificacion);
    }

    // Ordenar semestres
    final semestresOrdenados = agrupadas.keys.toList()
      ..sort(
        (a, b) => _obtenerOrdenSemestre(a).compareTo(_obtenerOrdenSemestre(b)),
      );

    final Map<String, List<Map<String, dynamic>>> resultado = {};
    for (var semestre in semestresOrdenados) {
      resultado[semestre] = agrupadas[semestre]!;
    }

    return resultado;
  }

  int _obtenerOrdenSemestre(String semestre) {
    final orden = {
      'Primer semestre': 1,
      'Segundo semestre': 2,
      'Tercer semestre': 3,
      'Cuarto semestre': 4,
      'Quinto semestre': 5,
      'Sexto semestre': 6,
      'Séptimo semestre': 7,
      'Octavo semestre': 8,
    };
    return orden[semestre] ?? 999;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollViewWidget(
      colorFondo: Utils.primaryColor,
      imagenFondo: Constantes.srcImgPortada1,
      titulo: NotificacionesPage.titlePage,
      silverList: SliverList(
        delegate: SliverChildListDelegate([_buildHeader(), _buildContenido()]),
      ),
    );
  }

  Widget _buildHeader() {
    final notificacionesNoLeidas = _notificaciones
        .where((n) => !n['leido'])
        .length;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y contador
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tus Notificaciones',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Utils.colorTextoBordesIconos,
                ),
              ),
              if (notificacionesNoLeidas > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Utils.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$notificacionesNoLeidas nuevas',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mantente al día con los nuevos materiales',
            style: TextStyle(
              fontSize: 14,
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _marcarTodasComoLeidas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Utils.colorTextoBordesIconos,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.checklist, size: 18),
                  label: const Text('Marcar todas como leídas'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _recargarNotificaciones,
                style: IconButton.styleFrom(
                  backgroundColor: Utils.colorFondoSecundario(0.2),
                ),
                icon: Icon(Icons.refresh, color: Utils.colorTextoBordesIconos),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    if (_notificacionesPorSemestre.isEmpty) {
      return _buildSinNotificaciones();
    }

    return Column(
      children: _notificacionesPorSemestre.entries.map((entry) {
        final semestre = entry.key;
        final notificaciones = entry.value;

        return _buildSeccionSemestre(semestre, notificaciones);
      }).toList(),
    );
  }

  Widget _buildSeccionSemestre(
    String semestre,
    List<Map<String, dynamic>> notificaciones,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header del semestre
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Utils.primaryColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.school, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                semestre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${notificaciones.length} material(es)',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Lista de notificaciones del semestre
        ...notificaciones.map(
          (notificacion) => _buildNotificacionItem(notificacion),
        ),
      ],
    );
  }

  Widget _buildNotificacionItem(Map<String, dynamic> notificacion) {
    final bool leido = notificacion['leido'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: leido
            ? Utils.colorFondoSecundario(0.1)
            : Utils.primaryColor.withValues(alpha: 0.1),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Utils.colorTextoBordesIconos.withValues(
                alpha: leido ? 0.3 : 0.8,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notificacion['icono'],
              color: leido ? Utils.colorTextoBordesIconos : Colors.white,
              size: 24,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      notificacion['titulo'],
                      style: TextStyle(
                        color: Utils.colorTextoBordesIconos,
                        fontSize: 16,
                        fontWeight: leido ? FontWeight.normal : FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!leido)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${notificacion['sigla']} - ${notificacion['materia']}',
                style: TextStyle(
                  color: Utils.colorTextoBordesIconos.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                notificacion['descripcion'],
                style: TextStyle(
                  color: Utils.colorTextoBordesIconos.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Utils.colorTextoBordesIconos.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      notificacion['tipo'],
                      style: TextStyle(
                        color: Utils.colorTextoBordesIconos,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    notificacion['fecha'],
                    style: TextStyle(
                      color: Utils.colorTextoBordesIconos.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () => _onNotificacionTap(notificacion),
        ),
      ),
    );
  }

  Widget _buildSinNotificaciones() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Utils.colorFondoSecundario(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Utils.colorTextoBordesIconos.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Utils.colorTextoBordesIconos.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay notificaciones',
            style: TextStyle(
              color: Utils.colorTextoBordesIconos,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cuando se suban nuevos materiales, aparecerán aquí',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Utils.colorTextoBordesIconos.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _recargarNotificaciones,
            style: ElevatedButton.styleFrom(
              backgroundColor: Utils.colorTextoBordesIconos,
              foregroundColor: Colors.white,
            ),
            child: const Text('Recargar'),
          ),
        ],
      ),
    );
  }

  void _onNotificacionTap(Map<String, dynamic> notificacion) {
    // Marcar como leída
    setState(() {
      notificacion['leido'] = true;
    });

    // Mostrar snackbar de confirmación
    Utils.showSnakbarInfo(
      'Notificación abierta',
      'Has visto: ${notificacion['titulo']}',
      2,
    );
  }

  void _marcarTodasComoLeidas() {
    setState(() {
      for (var notificacion in _notificaciones) {
        notificacion['leido'] = true;
      }
    });

    Utils.showSnakbarInfo(
      'Todas marcadas como leídas',
      'Todas las notificaciones han sido marcadas como leídas',
      2,
    );
  }

  void _recargarNotificaciones() {
    // Simular recarga
    setState(() {
      // En una app real, aquí harías una llamada a la API
    });

    Utils.showSnakbarInfo(
      'Notificaciones actualizadas',
      'Se han cargado las notificaciones más recientes',
      2,
    );
  }
}
