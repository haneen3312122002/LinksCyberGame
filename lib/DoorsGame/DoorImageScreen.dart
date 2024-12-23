// DoorImageScreen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // لاستعمال Timer
import 'DoorsScreen2.dart'; // التأكد من استيراد المرحلة الثانية
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class DoorImageScreen extends StatefulWidget {
  @override
  _DoorImageScreenState createState() => _DoorImageScreenState();
}

class _DoorImageScreenState extends State<DoorImageScreen> {
  late VideoPlayerController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // تشغيل فيديو afterdoor1.mp4
    _controller = VideoPlayerController.asset("assets/afterdoor1.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(false);

    // ضبط مؤقت للانتقال إلى المرحلة الثانية بعد 5 ثوانٍ
    _timer = Timer(Duration(seconds: 5), () {
      _navigateToNextScreen();
    });

    // الاستماع إلى نهاية الفيديو للانتقال إلى DoorScreen2 إذا انتهى الفيديو قبل 5 ثوانٍ
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoorsScreen2()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
