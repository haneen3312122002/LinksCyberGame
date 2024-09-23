import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'SessionLayerScreen.dart'; // الشاشة الرئيسية للعبة

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller; // مشغل الفيديو
  bool _isVideoEnded = false; // للتحقق من انتهاء الفيديو

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/sessionLayer.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // تشغيل الفيديو تلقائيًا
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isVideoEnded = true; // تم انتهاء الفيديو
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // تدمير الفيديو عند إغلاق الشاشة
    super.dispose();
  }

  // إعادة تشغيل الفيديو
  void _restartVideo() {
    setState(() {
      _isVideoEnded = false;
      _controller.seekTo(Duration.zero); // إعادة الفيديو إلى البداية
      _controller.play(); // تشغيل الفيديو مرة أخرى
    });
  }

  // الانتقال إلى الشاشة الرئيسية للعبة
  void _skipVideo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SessionLayerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),

          // الأزرار في أسفل الفيديو
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_isVideoEnded) // زر التخطي يظهر فقط إذا لم ينتهي الفيديو
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: _skipVideo,
                    child: Text('تخطي الفيديو'),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: _restartVideo,
                  child: Text('إعادة تشغيل الفيديو'),
                ),
              ),

              // هذا الزر يظهر فقط عند انتهاء الفيديو
              if (_isVideoEnded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: _skipVideo,
                    child: Text('البدء باللعبة'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
