import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final List<dynamic>? subtitles;
  const PlayerScreen({super.key, required this.videoUrl, this.subtitles});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  BetterPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    final subs = <BetterPlayerSubtitlesSource>[];
    if (widget.subtitles != null) {
      for (final s in widget.subtitles!) {
        final url = s['file_path'] ?? s['url'];
        final name = s['label'] ?? s['lang'] ?? 'sub';
        if (url != null) subs.add(BetterPlayerSubtitlesSource(type: BetterPlayerSubtitlesSourceType.network, name: name, urls: [url]));
      }
    }

    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      subtitles: subs,
      useAsmsSubtitles: true,
    );

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        autoPlay: true,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          controlBarColor: Colors.black45,
          iconsColor: const Color(0xFFFFD700),
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(children: [
          AspectRatio(aspectRatio: 16/9, child: BetterPlayer(controller: _controller!)),
          Expanded(child: Container(padding: const EdgeInsets.all(12), child: const Text('Información adicional y recomendaciones', style: TextStyle(color: Colors.white)))),
        ]),
      ),
    );
  }
}
