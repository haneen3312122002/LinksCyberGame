import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen2.dart';

class DoorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ضبط الصورة لتغطي كامل الخلفية
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.asset('assets/doors.png'),
          ),
        ),
        // الأبواب القابلة للضغط مع خلفية خلف النصوص
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDoor(context, 'اختيار البروتوكول',
                  isCorrect: true), // الباب الصحيح
              _buildDoor(context, 'اضافة بيانات الطلب', isCorrect: false),
              _buildDoor(context, 'ارسال الطلب', isCorrect: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoor(BuildContext context, String label,
      {required bool isCorrect}) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VideoScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label تم الضغط عليه')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150), // تعديل لرفع النصوص قليلاً إلى الأعلى
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 229, 130, 8)
                  .withOpacity(0.6), // خلفية نصف شفافة
              borderRadius: BorderRadius.circular(80),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/door1.mp4')
      ..initialize().then((_) {
        // تشغيل الفيديو تلقائياً
        _controller.play();
        setState(() {});
      })
      ..setLooping(false);

    // الانتقال إلى الشاشة التالية عند انتهاء الفيديو
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen2()),
        );
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
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              // لملء الشاشة بالكامل
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
