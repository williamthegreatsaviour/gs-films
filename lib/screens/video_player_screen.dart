import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cinepulso/models/movie.dart';
import 'package:cinepulso/theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;

  const VideoPlayerScreen({super.key, required this.movie});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _isFullscreen = false;

  late AnimationController _animationController;
  late Animation<double> _posterScaleAnimation;
  late Animation<double> _haloOpacityAnimation;
  Alignment _touchAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeWebView();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _posterScaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _haloOpacityAnimation = Tween<double>(begin: 0.25, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _animationController.repeat();
      }
    });

    _animationController.forward();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(GSFilmsColors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadHtmlString(_buildVideoPlayerHtml());
  }

  String _buildVideoPlayerHtml() {
    final videoUrl = widget.movie.videoUrl;
    final subtitleTrack = widget.movie.subtitleUrl != null
        ? '<track kind="subtitles" src="${widget.movie.subtitleUrl}" srclang="es" label="Español" default>'
        : '';
    final adTagUrl = widget.movie.adTagUrl ?? '';

    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>GSFilms Player</title>
        <link href="https://vjs.zencdn.net/8.5.2/video-js.css" rel="stylesheet">
        <link href="https://unpkg.com/videojs-contrib-ads@6.0.0/dist/videojs.ads.css" rel="stylesheet">
        <style>
            body { margin:0; padding:0; background-color:#000; }
            .video-js { width:100% !important; height:100vh !important; }
        </style>
    </head>
    <body>
        <video
            id="gsfilms-player"
            class="video-js vjs-default-skin"
            controls
            preload="auto"
            poster="${widget.movie.posterUrl}"
            data-setup='{"fluid": true, "responsive": true}'>
            <source src="$videoUrl" type="video/mp4">
            $subtitleTrack
            <p class="vjs-no-js">
                Para ver este video, actualiza a un navegador que soporte HTML5.
            </p>
        </video>

        <script src="https://vjs.zencdn.net/8.5.2/video.min.js"></script>
        <script src="https://unpkg.com/videojs-contrib-ads@6.0.0/dist/videojs.ads.min.js"></script>
        <script src="https://unpkg.com/videojs-ima@3.10.0/dist/videojs.ima.js"></script>

        <script>
            const player = videojs('gsfilms-player', {
                controls: true,
                fluid: true,
                responsive: true,
                playbackRates: [0.5,0.75,1,1.25,1.5,2]
            });

            player.ready(() => {
                try {
                    player.ima({ adTagUrl: '$adTagUrl', debug: false });
                    player.on('ended', () => console.log('Video finalizado'));
                } catch(e){
                    console.warn('Error al inicializar anuncios VAST:', e);
                }
            });
        </script>
    </body>
    </html>
    ''';
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: GSFilmsColors.richBlack,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: GSFilmsColors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(widget.movie.title,
                  style: const TextStyle(color: GSFilmsColors.white)),
              actions: [
                IconButton(
                  icon: Icon(
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: GSFilmsColors.white),
                  onPressed: _toggleFullscreen,
                ),
              ],
            ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            GestureDetector(
              onPanUpdate: (details) {
                final size = MediaQuery.of(context).size;
                setState(() {
                  _touchAlignment = Alignment(
                    (details.localPosition.dx / size.width) * 2 - 1,
                    (details.localPosition.dy / size.height) * 2 - 1,
                  );
                });
              },
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _posterScaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: RadialGradient(
                            colors: [
                              GSFilmsColors.neonGold
                                  .withOpacity(_haloOpacityAnimation.value),
                              Colors.transparent
                            ],
                            stops: const [0.0, 1.0],
                            center: _touchAlignment,
                            radius: 0.9,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: GSFilmsColors.neonGold
                                  .withOpacity(_haloOpacityAnimation.value / 1.5),
                              blurRadius: 25,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.movie.posterUrl,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text('Cargando video...',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: GSFilmsColors.white)),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    GSFilmsColors.neonGold),
                                strokeWidth: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
