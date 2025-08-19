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

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(GSFilmsColors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadHtmlString(_buildVideoPlayerHtml());
  }

  String _buildVideoPlayerHtml() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>GSFilms Player</title>
        <link href="https://vjs.zencdn.net/8.5.2/video-js.css" rel="stylesheet">
        <style>
            body {
                margin: 0;
                padding: 0;
                background-color: #000;
                font-family: Arial, sans-serif;
            }
            
            .video-container {
                width: 100%;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            
            .movie-info {
                color: #FFD700;
                text-align: center;
                padding: 20px;
                background: rgba(0, 0, 0, 0.8);
                border-radius: 10px;
                margin: 20px;
            }
            
            .movie-title {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 10px;
            }
            
            .movie-details {
                font-size: 16px;
                color: #ccc;
                margin-bottom: 20px;
            }
            
            .video-js {
                width: 100% !important;
                height: auto !important;
                max-height: 70vh;
            }
            
            .demo-notice {
                background: rgba(255, 215, 0, 0.1);
                border: 1px solid #FFD700;
                color: #FFD700;
                padding: 20px;
                border-radius: 10px;
                margin: 20px;
                text-align: center;
            }
            
            .play-button {
                background: linear-gradient(135deg, #FFD700, #B8860B);
                color: #000;
                border: none;
                padding: 15px 30px;
                border-radius: 25px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                margin: 20px;
                box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
                transition: all 0.3s ease;
            }
            
            .play-button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255, 215, 0, 0.6);
            }
            
            .feature-list {
                color: #ccc;
                text-align: left;
                margin: 20px auto;
                max-width: 400px;
            }
            
            .feature-list li {
                margin: 10px 0;
                padding-left: 20px;
                position: relative;
            }
            
            .feature-list li:before {
                content: "✓";
                color: #FFD700;
                font-weight: bold;
                position: absolute;
                left: 0;
            }
        </style>
    </head>
    <body>
        <div class="video-container">
            <div class="movie-info">
                <div class="movie-title">\${widget.movie.title}</div>
                <div class="movie-details">\${widget.movie.genre} • \${widget.movie.duration}</div>
                
                <div class="demo-notice">
                    <h3>🎬 Reproductor GSFilms</h3>
                    <p>Esta es una demostración del reproductor de video integrado con Video.js</p>
                    
                    <ul class="feature-list">
                        <li>Soporte para subtítulos (.vtt)</li>
                        <li>Múltiples pistas de audio</li>
                        <li>Controles de reproducción avanzados</li>
                        <li>Reproducción en pantalla completa</li>
                        <li>Interfaz responsive</li>
                    </ul>
                </div>
                
                <button class="play-button" onclick="playDemo()">
                    ▶ Reproducir Demo
                </button>
            </div>
            
            <video
                id="demo-player"
                class="video-js vjs-default-skin"
                controls
                preload="auto"
                data-setup='{"fluid": true}'
                style="display: none;">
                <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                <track kind="captions" src="" srclang="es" label="Español" default>
                <p class="vjs-no-js">
                    Para ver este video, habilite JavaScript y considere actualizar a un
                    <a href="https://videojs.com/html5-video-support/" target="_blank">navegador que soporte HTML5 video</a>.
                </p>
            </video>
        </div>

        <script src="https://vjs.zencdn.net/8.5.2/video.min.js"></script>
        <script>
            let player;
            
            function playDemo() {
                const videoElement = document.getElementById('demo-player');
                videoElement.style.display = 'block';
                
                player = videojs('demo-player', {
                    controls: true,
                    fluid: true,
                    responsive: true,
                    playbackRates: [0.5, 1, 1.25, 1.5, 2],
                    plugins: {
                        // Aquí se pueden agregar plugins adicionales
                    }
                });
                
                player.ready(function() {
                    console.log('Player is ready');
                    player.play();
                });
                
                // Manejar pantalla completa
                player.on('fullscreenchange', function() {
                    console.log('Fullscreen changed');
                });
                
                // Manejar eventos de reproducción
                player.on('play', function() {
                    console.log('Video started playing');
                });
                
                player.on('ended', function() {
                    console.log('Video ended');
                });
            }
            
            // Limpiar el reproductor al salir
            window.addEventListener('beforeunload', function() {
                if (player) {
                    player.dispose();
                }
            });
        </script>
    </body>
    </html>
    ''';
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GSFilmsColors.black,
      appBar: _isFullscreen ? null : AppBar(
        backgroundColor: GSFilmsColors.richBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GSFilmsColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.movie.title,
          style: const TextStyle(color: GSFilmsColors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: GSFilmsColors.white,
            ),
            onPressed: _toggleFullscreen,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: GSFilmsColors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(GSFilmsColors.neonGold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Cargando reproductor...',
                      style: TextStyle(color: GSFilmsColors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}