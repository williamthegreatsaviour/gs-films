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
    final videoUrl = widget.movie.videoUrl;
    final subtitleTrack = widget.movie.subtitleUrl != null
        ? '<track kind="subtitles" src="${widget.movie.subtitleUrl}" srclang="es" label="Español" default>'
        : '';

    final adTagUrl = widget.movie.adTagUrl ??
        'https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=';

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
            body {
                margin: 0;
                padding: 0;
                background-color: #000;
                font-family: Arial, sans-serif;
            }
            .video-js {
                width: 100% !important;
                height: 100vh !important;
            }
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
            let player;
            function initPlayer() {
                player = videojs('gsfilms-player', {
                    controls: true,
                    fluid: true,
                    responsive: true,
                    playbackRates: [0.5, 0.75, 1, 1.25, 1.5, 2],
                    plugins: {
                        ima: {
                            id: 'gsfilms-player',
                            adTagUrl: '$adTagUrl'
                        }
                    }
                });

                player.ready(function() {
                    try {
                        player.ima.initializeAdDisplayContainer();
                        player.ima.setContentWithAdTag(player.currentSource(), '$adTagUrl');
                        player.ima.requestAds();
                    } catch (e) {
                        console.warn('Error al cargar anuncios:', e);
                    }
                });

                player.on('ended', function() {
                    console.log('Reproducción finalizada');
                });
            }

            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', initPlayer);
            } else {
                initPlayer();
            }
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
