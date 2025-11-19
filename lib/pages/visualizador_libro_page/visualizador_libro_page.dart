import 'package:flutter/material.dart';
import 'package:uni_share/utils/constantes/constantes.dart';
import 'package:uni_share/utils/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VisualizadorLibroPage extends StatefulWidget {
  final String urlLibro;
  final String nombreLibro;
  final String nombreMateria;
  final String siglaMateria;

  const VisualizadorLibroPage({
    super.key,
    required this.urlLibro,
    required this.nombreLibro,
    required this.nombreMateria,
    required this.siglaMateria,
  });

  @override
  State<VisualizadorLibroPage> createState() => _VisualizadorLibroPageState();
}

class _VisualizadorLibroPageState extends State<VisualizadorLibroPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  double _progress = 0;
  String _viewerUrl = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  String _getViewerUrl(String fileUrl) {
    final url = fileUrl.toLowerCase();

    // PDF - Usar Google Docs Viewer
    if (url.contains('.pdf')) {
      return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fileUrl)}';
    }

    // Documentos de Word
    if (url.contains('.doc') || url.contains('.docx')) {
      return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(fileUrl)}';
    }

    // Presentaciones PowerPoint
    if (url.contains('.ppt') || url.contains('.pptx')) {
      return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(fileUrl)}';
    }

    // Hojas de cálculo Excel
    if (url.contains('.xls') || url.contains('.xlsx')) {
      return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(fileUrl)}';
    }

    // Archivos de texto
    if (url.contains('.txt')) {
      // Para archivos de texto, los cargamos directamente
      return fileUrl;
    }

    // Imágenes - mostrar directamente
    if (url.contains('.jpg') ||
        url.contains('.jpeg') ||
        url.contains('.png') ||
        url.contains('.gif') ||
        url.contains('.bmp') ||
        url.contains('.webp')) {
      return fileUrl;
    }

    // Por defecto, usar Google Docs Viewer
    return 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fileUrl)}';
  }

  bool _needsDirectLoad(String fileUrl) {
    final url = fileUrl.toLowerCase();
    return url.contains('.txt') ||
        url.contains('.jpg') ||
        url.contains('.jpeg') ||
        url.contains('.png') ||
        url.contains('.gif') ||
        url.contains('.bmp') ||
        url.contains('.webp');
  }

  void _initializeWebView() {
    _viewerUrl = _getViewerUrl(widget.urlLibro);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Utils.colorFondoPrincipal)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
              _progress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _progress = 1.0;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Permitir todas las navegaciones
            return NavigationDecision.navigate;
          },
        ),
      );
    // Cargar la URL
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    try {
      if (_needsDirectLoad(widget.urlLibro)) {
        // Para archivos que se pueden cargar directamente (imágenes, txt)
        await _controller.loadRequest(
          Uri.parse(_viewerUrl),
          headers: {
            'Authorization': 'Bearer ${Constantes.clavePublicaSupabase}',
            'apikey': Constantes.clavePublicaSupabase,
          },
        );
      } else {
        // Para archivos que necesitan viewer (PDF, Office)
        await _controller.loadRequest(Uri.parse(_viewerUrl));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _recargarPagina() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _progress = 0;
    });
    _loadUrl();
  }

  void _abrirEnNavegadorExterno() {
    try {
      Utils.launchInBrowser(widget.urlLibro);
      Utils.showSnakbarInfo(
        "Abriendo en navegador",
        "El documento se abrirá en tu navegador externo",
        2,
      );
    } catch (e) {
      Utils.showSnakbarError(
        "Error",
        "No se pudo abrir en el navegador: $e",
        3,
      );
    }
  }

  String _getTipoArchivo() {
    final url = widget.urlLibro.toLowerCase();
    if (url.contains('.pdf')) return 'PDF';
    if (url.contains('.doc')) return 'Documento Word';
    if (url.contains('.docx')) return 'Documento Word';
    if (url.contains('.ppt') || url.contains('.pptx')) return 'Presentación';
    if (url.contains('.xls') || url.contains('.xlsx')) return 'Hoja de cálculo';
    if (url.contains('.txt')) return 'Archivo de texto';
    if (url.contains('.jpg') || url.contains('.jpeg')) return 'Imagen JPEG';
    if (url.contains('.png')) return 'Imagen PNG';
    if (url.contains('.gif')) return 'Imagen GIF';
    if (url.contains('.bmp')) return 'Imagen BMP';
    return 'Archivo';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.primaryColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Utils.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 28),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.nombreLibro,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${widget.siglaMateria} - ${_getTipoArchivo()}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final isImage = _isImageFile(widget.urlLibro);
    final isText = widget.urlLibro.toLowerCase().contains('.txt');

    return Column(
      children: [
        // Barra de progreso
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Utils.colorFondoPrincipal,
            valueColor: AlwaysStoppedAnimation<Color>(
              Utils.colorErroresAdvertencias,
            ),
            minHeight: 3,
          ),

        // Contador de progreso
        if (_isLoading && _progress > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        // Contenido principal
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Utils.colorFondoPrincipal,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  // WebView principal
                  if (!isImage && !isText)
                    WebViewWidget(controller: _controller),

                  // Visualizador de imágenes
                  if (isImage && !_isLoading && !_hasError) _buildImageViewer(),

                  // Visualizador de texto
                  if (isText && !_isLoading && !_hasError) _buildTextViewer(),

                  // Estado de carga
                  if (_isLoading)
                    Container(
                      color: Utils.colorFondoPrincipal.withValues(alpha: 0.95),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLoadingAnimation(),
                            const SizedBox(height: 20),
                            Utils.estiloTexto(
                              "Cargando ${_getTipoArchivo().toLowerCase()}...",
                              16.0,
                              true,
                              Utils.colorTextoBordesIconos,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_progress * 100).toInt()}% completado',
                              style: TextStyle(
                                color: Utils.colorTextoBordesIconos.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Estado de error
                  if (_hasError)
                    Container(
                      color: Utils.colorFondoPrincipal.withValues(alpha: 0.95),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.error_outline,
                                  size: 50,
                                  color: Colors.red.shade400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Utils.estiloTexto(
                                "Error al cargar el archivo",
                                18.0,
                                true,
                                Colors.red.shade400,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Utils.estiloTexto(
                                  "No se pudo cargar el ${_getTipoArchivo().toLowerCase()}. Verifique su conexión a internet.",
                                  14.0,
                                  false,
                                  Utils.colorTextoBordesIconos,
                                  true,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _recargarPagina,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Utils.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(Icons.refresh, size: 20),
                                    label: const Text("REINTENTAR"),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: _abrirEnNavegadorExterno,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          Utils.colorTextoBordesIconos,
                                      side: BorderSide(
                                        color: Utils.colorTextoBordesIconos,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.open_in_browser,
                                      size: 20,
                                    ),
                                    label: const Text("NAVEGADOR"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageViewer() {
    return FutureBuilder<String>(
      future: _loadImageContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Utils.colorErroresAdvertencias,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Utils.estiloTexto(
                  "Error al cargar la imagen",
                  16.0,
                  true,
                  Colors.red.shade400,
                ),
              ],
            ),
          );
        } else {
          return InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                widget.urlLibro,
                headers: {
                  'Authorization': 'Bearer ${Constantes.clavePublicaSupabase}',
                  'apikey': Constantes.clavePublicaSupabase,
                },
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Utils.estiloTexto(
                        "No se pudo cargar la imagen",
                        16.0,
                        true,
                        Colors.grey.shade600,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildTextViewer() {
    return FutureBuilder<String>(
      future: _loadTextContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Utils.colorErroresAdvertencias,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Utils.estiloTexto(
                  "Error al cargar el texto",
                  16.0,
                  true,
                  Colors.red.shade400,
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: SelectableText(
                snapshot.data ?? 'No se pudo cargar el contenido',
                style: TextStyle(
                  color: Utils.colorTextoBordesIconos,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> _loadImageContent() async {
    // Simplemente retornar la URL para Image.network
    return widget.urlLibro;
  }

  Future<String> _loadTextContent() async {
    try {
      final response =
          await _controller.runJavaScriptReturningResult(
                'document.body.innerText',
              )
              as String;
      return response;
    } catch (e) {
      // Si falla, intentar cargar directamente
      try {
        final http =
            await _controller.runJavaScriptReturningResult(
                  'fetch("${widget.urlLibro}", { headers: { "Authorization": "Bearer ${Constantes.clavePublicaSupabase}", "apikey": "${Constantes.clavePublicaSupabase}" } }).then(r => r.text())',
                )
                as String;
        return http;
      } catch (e) {
        return 'Contenido no disponible. Use el botón "Descargar" para ver el archivo.';
      }
    }
  }

  bool _isImageFile(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png') ||
        lowerUrl.contains('.gif') ||
        lowerUrl.contains('.bmp') ||
        lowerUrl.contains('.webp');
  }

  Widget _buildLoadingAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Utils.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Utils.colorErroresAdvertencias,
            ),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Utils.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(_getDocumentIcon(), color: Colors.white, size: 30),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _recargarPagina,
      backgroundColor: Utils.primaryColor,
      foregroundColor: Colors.white,
      child: const Icon(Icons.refresh, size: 28),
    );
  }

  IconData _getDocumentIcon() {
    final url = widget.urlLibro.toLowerCase();
    if (url.contains('.pdf')) return Icons.picture_as_pdf;
    if (url.contains('.doc') || url.contains('.docx')) return Icons.description;
    if (url.contains('.ppt') || url.contains('.pptx')) return Icons.slideshow;
    if (url.contains('.xls') || url.contains('.xlsx')) return Icons.table_chart;
    if (url.contains('.txt')) return Icons.text_snippet;
    if (url.contains('.jpg') ||
        url.contains('.jpeg') ||
        url.contains('.png') ||
        url.contains('.gif')) {
      return Icons.image;
    }
    return Icons.insert_drive_file;
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }
}
