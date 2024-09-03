import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoPath;

  FullScreenVideoPlayer({required this.videoPath});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(
            () {}); // Ensure the first frame is shown after the video is initialized
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context);
      }
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
      body: Center(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit
                    .cover, // This ensures the video covers the entire screen
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class Door1VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullScreenVideoPlayer(videoPath: 'assets/door1.mp4');
  }
}

class Door2VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullScreenVideoPlayer(videoPath: 'assets/door2.mp4');
  }
}

class Door3VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FullScreenVideoPlayer(videoPath: 'assets/door3.mp4');
  }
}
