import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'CryptoGameScreen.dart';

class PassVideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<PassVideoScreen> {
  late VideoPlayerController _controller;
  late AudioPlayer _backgroundMusicPlayer; // مشغل موسيقى الخلفية
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/PassVideo.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(false);
      });

    // تهيئة وتشغيل موسيقى الخلفية
    _backgroundMusicPlayer = AudioPlayer();
    _playBackgroundMusic();

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.setAsset('assets/LinkSong.mp3');
      _backgroundMusicPlayer.setVolume(0.3);
      _backgroundMusicPlayer.setLoopMode(LoopMode.one); // تكرار الموسيقى
      await _backgroundMusicPlayer.play();
      print("Background music started playing."); // تأكيد التشغيل
    } catch (e) {
      print("Failed to play background music: $e"); // طباعة أي خطأ
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundMusicPlayer.dispose(); // إيقاف الموسيقى عند الخروج
    super.dispose();
  }

  void _skipVideo() {
    _controller.pause();
    _backgroundMusicPlayer
        .stop(); // إيقاف موسيقى الخلفية عند الانتقال للشاشة التالية
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CryptoGameScreen()),
    );
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