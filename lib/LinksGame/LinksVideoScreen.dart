import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'gameScree.dart';

class LinksVideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<LinksVideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/the_char.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false); // No auto-repeat
      });

    // Listen to video end to stop playing
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isPlaying = false; // Update button state
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _skipVideo() {
    _controller.pause(); // Pause the video to stop sound
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
                IconButton(
                  onPressed: _skipVideo,
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.green,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
