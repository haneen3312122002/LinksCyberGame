import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class MarioBackground extends StatefulWidget {
  @override
  _MarioBackgroundState createState() => _MarioBackgroundState();
}

class _MarioBackgroundState extends State<MarioBackground> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    // إعدادات مشغل الفيديو
    _videoController = VideoPlayerController.asset('assets/MarioBackground.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true); // تكرار الفيديو
        _videoController.play(); // تشغيل الفيديو
        _startAudio(); // تشغيل الصوت
        setState(() {}); // تحديث الحالة بعد تهيئة الفيديو
      });

    // تهيئة مشغل الصوت
    _audioPlayer = AudioPlayer();
  }

  // تشغيل الصوت مع تكراره
  void _startAudio() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // تكرار الصوت
    await _audioPlayer.play(AssetSource('carsong.mp3')); // تشغيل الصوت
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.stop(); // إيقاف الصوت عند التخلص من الكائن
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
        : Container(color: const Color.fromARGB(255, 248, 183, 216));
  }
}
