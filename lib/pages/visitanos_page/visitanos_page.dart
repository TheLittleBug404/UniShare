import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:uni_share/controllers/loading_controller/loading_controller.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitanosPage extends StatefulWidget {
  static const String titlePage = 'Visitanos';
  static const String smallTitlePage = 'Visitanos';
  static const String titlePageResumen = 'Visitanos';
  static const String route = '/visitanos_page';
  static const IconData icon = Icons.location_on;

  const VisitanosPage({super.key});

  @override
  State<VisitanosPage> createState() => _VisitanosPageState();
}

class _VisitanosPageState extends State<VisitanosPage> {
  final MapController _mapController = MapController();
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  final loadingC = Get.find<LoadingController>();

  LatLng _currentLocation = const LatLng(0, 0);
  int _locationSwitch = 0;
  double? _direction;
  bool _showCarreraDialog = false;

  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocationServices();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _serviceStatusStreamSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _initializeLocationServices() {
    _toggleServiceStatusStream();
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = GeolocatorPlatform.instance
          .getServiceStatusStream();
      _serviceStatusStreamSubscription = serviceStatusStream
          .handleError((error) {
            _serviceStatusStreamSubscription?.cancel();
            _serviceStatusStreamSubscription = null;
          })
          .listen((serviceStatus) {
            _updatePositionList(
              _PositionItemType.log,
              'Location service has been ${serviceStatus == ServiceStatus.enabled ? 'enabled' : 'disabled'}',
            );
          });
    }
  }
  void _toggleLocationListening() async {
    log("Presionaste el boton de ubicacion");

    bool internet = await Utils.hasInternet();
    if (!internet) {
      Utils.showSnakbarSinInternet(
        "Sin conexión a internet",
        "Revise su conexión a internet",
        4,
      );
      return;
    }

    // Verificar si los servicios de ubicacion estan activados
    bool localizacionActivada = await Geolocator.isLocationServiceEnabled();
    if (!localizacionActivada) {
      Utils.showSnakbarError(
        "Ubicación desactivada",
        "Active los servicios de ubicación para continuar",
        4,
      );
      return;
    }

    // Verificar permisos de ubicación
    LocationPermission permisosUbicacion = await Geolocator.checkPermission();
    if (permisosUbicacion == LocationPermission.denied ||
        permisosUbicacion == LocationPermission.deniedForever) {
      permisosUbicacion = await Geolocator.requestPermission();

      if (permisosUbicacion == LocationPermission.denied ||
          permisosUbicacion == LocationPermission.deniedForever) {
        Utils.showSnakbarError(
          "Permisos de ubicación requeridos",
          "Active los permisos de ubicación en la configuración",
          4,
        );
        return;
      }
    }

    try {
      loadingC.setOnLoading();
      log("Iniciando loading: ${loadingC.getLoading}");

      // Agregar un pequeño delay para que el loading sea visible
      await Future.delayed(const Duration(milliseconds: 100));

      // Si no existe el stream, crearlo y empezar a escuchar inmediatamente
      if (_positionStreamSubscription == null) {
        await _startLocationStreamWithLoading();
      } else {
        // Si el stream existe, toggle entre pausar y reanudar
        if (_positionStreamSubscription!.isPaused) {
          _positionStreamSubscription!.resume();
          _updatePositionList(
            _PositionItemType.log,
            'Listening for position updates resumed',
          );

          // Esperar un momento para que se obtenga la ubicación
          await Future.delayed(const Duration(seconds: 2));

          // Mover el mapa a la ubicación actual cuando se reanuda
          if (_currentLocation.latitude != 0 &&
              _currentLocation.longitude != 0) {
            _moveToCurrentLocation();
          }
        } else {
          _positionStreamSubscription!.pause();
          _updatePositionList(
            _PositionItemType.log,
            'Listening for position updates paused',
          );
        }
      }

      setState(() {});
    } catch (e) {
      log("Error en toggleLocationListening: $e");
      Utils.showSnakbarError(
        "Error",
        "Ocurrió un error, inténtelo más tarde",
        4,
      );
    } finally {
      // Ocultar loading después de un tiempo mínimo para que sea visible
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          loadingC.setOffLoading();
          log("Finalizando loading: ${loadingC.getLoading}");
        }
      });
    }
  }

  // Nuevo método que maneja el loading para el stream de ubicación
  Future<void> _startLocationStreamWithLoading() async {
    final completer = Completer<void>();
    bool firstLocationReceived = false;

    final androidSettings = AndroidSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
      forceLocationManager: false,
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText: "Está utilizando el GPS de su dispositivo",
        notificationTitle: "UniShare",
        enableWakeLock: false,
      ),
    );

    final positionStream = GeolocatorPlatform.instance.getPositionStream(
      locationSettings: androidSettings,
    );

    _positionStreamSubscription = positionStream
        .handleError((error) async {
          log("Error en stream de ubicación: $error");
          if (!completer.isCompleted) {
            completer.complete();
          }

          final hasPermission = await _checkLocationPermission();
          _positionStreamSubscription?.cancel();
          _positionStreamSubscription = null;

          setState(() {});

          if (!hasPermission) {
            Utils.showSnakbarError(
              "Error de ubicación",
              "Revise los permisos de ubicación",
              4,
            );
          } else {
            Utils.showSnakbarError(
              "Error de GPS",
              "No se pudo obtener la ubicación",
              4,
            );
          }
        })
        .listen((position) {
          log("Nueva ubicación: ${position.latitude}, ${position.longitude}");
          if (mounted) {
            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
            });

            // Mover el mapa a la nueva ubicación automáticamente solo la primera vez
            if (_locationSwitch == 0) {
              _moveToCurrentLocation();
              _locationSwitch++;
            }

            // Completar el completer cuando recibamos la primera ubicación
            if (!firstLocationReceived) {
              firstLocationReceived = true;
              if (!completer.isCompleted) {
                completer.complete();
              }
            }
          }
        });

    // Timeout para evitar que el loading se quede eternamente
    Future.delayed(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.complete();
        log("Timeout en la obtención de ubicación");
      }
    });

    // Esperar a que se reciba la primera ubicación o timeout
    await completer.future;

    _positionStreamSubscription?.resume();
    _updatePositionList(
      _PositionItemType.log,
      'Started listening for position updates',
    );

    _handleCompassDirection();
  }

  // Método auxiliar para mover el mapa a la ubicación actual
  void _moveToCurrentLocation() {
    try {
      // Verificar si tenemos una ubicación válida
      if (_currentLocation.latitude != 0 && _currentLocation.longitude != 0) {
        _mapController.move(
          _currentLocation,
          _mapController.zoom > 17.0 ? _mapController.zoom : 17.0,
        );
      }
    } catch (e) {
      log("Error moviendo el mapa: $e");
      // El controlador podría no estar listo todavía, pero no es crítico
    }
  }

  Future<bool> _checkLocationPermission() async {
    final serviceEnabled = await GeolocatorPlatform.instance
        .isLocationServiceEnabled();
    if (!serviceEnabled) {
      Utils.showSnakbarInfo(
        "Advertencia",
        "Servicios de ubicación desactivados",
        4,
      );
      return false;
    }

    LocationPermission permission = await GeolocatorPlatform.instance
        .checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await GeolocatorPlatform.instance.requestPermission();
      if (permission == LocationPermission.denied) {
        Utils.showSnakbarInfo(
          "Revise permisos",
          "Permisos de ubicación denegados",
          4,
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Utils.showSnakbarError("Error", "Permisos de ubicación denegados", 4);
      return false;
    }

    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
  }

  void _handleCompassDirection() {
    // Implementar lógica del compás si es necesaria
  }

  bool _isListening() =>
      _positionStreamSubscription != null &&
      !_positionStreamSubscription!.isPaused;

  Color _getButtonColor() {
    return _isListening()
        ? Utils.colorFondoSecundario(0.9)
        : Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => LoadingOverlay(
          progressIndicator: Utils.loadingCustom(),
          color: Colors.white.withValues(alpha: 0.6),
          isLoading: loadingC.getLoading,
          child: _buildMapContent(context),
        ),
      ),
    );
  }

  Widget _buildMapContent(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: Stack(children: [_buildMap(), _buildLocationButton()])),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: Get.mediaQuery.padding.top + 16,
        left: 16,
        right: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Utils.colorFondosSecundariosBordesSuaves,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Utils.colorTextoBordesIconos,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Visitanos - Ubicación',
              style: TextStyle(
                color: Utils.colorTextoBordesIconos,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------
  Widget _buildLocationButton() {
    return Positioned(
      bottom: 20,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Utils.colorPrimario(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() {
          // Mostrar indicador de loading en el botón también
          if (loadingC.getLoading) {
            return FloatingActionButton(
              onPressed: null, // Deshabilitado durante loading
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              elevation: 4,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Utils.primaryColor),
                ),
              ),
            );
          }

          return FloatingActionButton(
            onPressed: _toggleLocationListening,
            backgroundColor: _getButtonColor(),
            foregroundColor: Colors.white,
            elevation: 4,
            child: _isListening()
                ? Icon(Icons.location_searching, size: 28, color: Colors.white)
                : Icon(
                    Icons.location_disabled,
                    size: 28,
                    color: Colors.white70,
                  ),
          );
        }),
      ),
    );
  }
  Widget _buildMap() {
    final markerLayer = MarkerLayer(
      markers: [
        _buildCarreraInformaticaMarker(),
        if (_isListening()) _buildUserLocationMarker(),
      ],
    );

    final wmsLayer = TileLayer(
      backgroundColor: Colors.transparent,
      wmsOptions: WMSTileLayerOptions(
        baseUrl: 'https://edogeoserver.et.bo/geoserver/wms?',
        layers: ['EDO_Workspace:PUNTOS_COBRANZA'],
      ),
    );

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: const LatLng(-16.503916836667333, -68.12901812911998),
        maxZoom: 19,
        minZoom: 5,
        zoom: 13,
        interactiveFlags:
            InteractiveFlag.pinchZoom |
            InteractiveFlag.drag |
            InteractiveFlag.pinchMove |
            InteractiveFlag.doubleTapZoom |
            InteractiveFlag.flingAnimation,
        onTap: (tapPosition, point) {
          _handleMapTap(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: Get.isDarkMode
              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
              : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
          userAgentPackageName: 'com.jauregui.unishare',
          subdomains: const ['a', 'b', 'c'],
        ),
        wmsLayer,
        markerLayer,
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }

  void _handleMapTap(LatLng point) {
    const carreraLocation = LatLng(-16.503916836667333, -68.12901812911998);
    final distance = _calculateDistance(point, carreraLocation);

    log("Distancia al marker: $distance km");

    // Aumentar el radio de detección para hacerlo más sensible
    if (distance < 0.1) {
      // 0.1 km = 100 metros
      _showCarreraInformaticaDialog();
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const distance = Distance();
    return distance(point1, point2) / 1000;
  }

  Marker _buildCarreraInformaticaMarker() {
    return Marker(
      width: 70,
      height: 70,
      point: const LatLng(-16.503916836667333, -68.12901812911998),
      builder: (ctx) {
        return GestureDetector(
          onTap: () {
            log("Tap directo en el marker de Carrera de Informática");
            _showCarreraInformaticaDialog();
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Efecto de pulso
                  if (_isListening())
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Utils.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Utils.colorPrimario(0.9),
                      border: Border.all(
                        color: Utils.colorTextoBordesIconos,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school,
                      color: Utils.colorTextoBordesIconos,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCarreraInformaticaDialog() {
    if (_showCarreraDialog) return;

    _showCarreraDialog = true;

    Future.delayed(Duration.zero, () {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: Get.width * 0.8,
              height: Get.height * 0.5,
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
                    Utils.colorFondoSecundario(1.0), //Utils.colorPrimario(1.0),
                    Utils.colorFondoSecundario(0.9),
                    Colors.white, //Utils.colorFondoSecundario(0.1),
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
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors
                                .white, //Utils.primaryColor.withValues(alpha: 0.1),
                          ),
                        ),
                        // Icono principal
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Utils.colorTextoBordesIconos,
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .white, //Utils.primaryColor.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Título principal
                    Text(
                      "Carrera de Informática",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // Subtítulo
                    Text(
                      "FCPN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Imagen con marco decorativo
                    Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, //Utils.colorTextoBordesIconos,
                          width: 2,
                        ),
                      ),
                      child: _buildCarreraImage(),
                    ),

                    const SizedBox(height: 20),

                    // Información adicional
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Utils.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Utils.colorPrimario(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.location_on,
                            "Carrera de Informatica",
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.phone, "(2) 244-0338"),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.email,
                            "informatica@informatica.edu.bo",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón de cerrar mejorado
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showCarreraDialog = false;
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Utils
                              .colorTextoBordesIconos, //Utils.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors
                              .white, //Utils.primaryColor.withValues(alpha: 0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cerrar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.close, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).then((_) {
          _showCarreraDialog = false;
        });
      }
    });
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarreraImage() {
    try {
      return ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white, //Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            'assets/img/logo_carrera_informatica.webp',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Utils.colorFondoSecundario(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.school, color: Colors.white, size: 40),
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Utils.colorFondoSecundario(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.school, color: Utils.primaryColor, size: 40),
      );
    }
  }

  Marker _buildUserLocationMarker() {
    return Marker(
      width: 60.0,
      height: 60.0,
      point: _currentLocation,
      builder: (ctx) {
        return Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (_direction != null)
                  ClipOval(
                    child: Transform.rotate(
                      angle:
                          (((_direction! * -1)) * (math.pi / 180) * -1) + 160,
                      child: CustomPaint(
                        size: const Size(60.0, 60.0),
                        painter: _DirectionPainter(Utils.primaryColor),
                      ),
                    ),
                  ),
                Container(
                  height: 24.0,
                  width: 24.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Utils.primaryColor.withValues(alpha: 0.9),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Utils.colorPrimario(1.0),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DirectionPainter extends CustomPainter {
  final Color directionColor;

  _DirectionPainter(this.directionColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: const Offset(30.0, 30.0),
      radius: 40.0,
    );

    final Gradient gradient = RadialGradient(
      colors: <Color>[
        directionColor.withValues(alpha: 0.8),
        directionColor.withValues(alpha: 0.5),
        directionColor.withValues(alpha: 0.3),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawArc(rect, math.pi / 5, math.pi * 3 / 5, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum _PositionItemType { log }

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
