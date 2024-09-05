import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen.dart';

class DoorsVideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<DoorsVideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/DoorsVideo.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false); // لا يعيد تشغيل الفيديو تلقائيًا
      });

    // للاستماع إلى نهاية الفيديو وإيقاف التشغيل
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isPlaying = false; // تحديث حالة الزر
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Play/Pause functionality
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

  // Skip video and navigate to DoorsScreen
  void _skipVideo() {
    // Stop the video and dispose the controller
    _controller.pause(); // Pause the video
    _controller.seekTo(Duration.zero); // Reset the video to the start

    // Navigate to DoorsScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DoorsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Show the video player only after the video has been initialized
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
            )
          else
            // Show a loading indicator while the video is initializing
            Center(child: CircularProgressIndicator()),

          // Play/Pause and Skip buttons
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Play/Pause Button
                IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
                // Skip Button
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
