import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cinepulso/models/movie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;

  const VideoPlayerScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  double? lastWatchedPosition;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    lastWatchedPosition = widget.movie.lastWatchedPosition;

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.movie.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _isInitialized = true;
        });

        if (lastWatchedPosition != null && lastWatchedPosition! > 0) {
          _controller.seekTo(Duration(milliseconds: (lastWatchedPosition! * 1000).toInt()));
        }

        _controller.play();
        _controller.setLooping(false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
