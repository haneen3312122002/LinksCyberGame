import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen5.dart'; // تأكد من أن الصفحة DoorsScreen5 معرفة بشكل صحيح

class DoorsScreen4 extends StatefulWidget {
  @override
  _DoorsScreen4State createState() => _DoorsScreen4State();
}

class _DoorsScreen4State extends State<DoorsScreen4> {
  late VideoPlayerController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ضبط الصورة لتغطي كامل الخلفية
        Positioned.fill(
          child: Image.asset(
            'assets/doors.png',
            fit: BoxFit.cover, // جعل الصورة تغطي كامل المساحة
          ),
        ),
        // الأبواب القابلة للضغط مع خلفية خلف النصوص
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDoor(context, 'إعداد الرؤوس', true), // الجواب الصحيح
              _buildDoor(context, 'اختيار بروتوكول', false),
              _buildDoor(context, 'انتظار الرد', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoor(BuildContext context, String label, bool isCorrect) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          _playVideoAndNavigate(
              context); // تشغيل الفيديو والانتقال للصفحة التالية
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خاطئ! $label ليس الخيار الصحيح.')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 229, 130, 8).withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
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

  Future<void> _playVideoAndNavigate(BuildContext context) async {
    _controller = VideoPlayerController.asset('assets/door1.mp4');
    await _controller.initialize();

    // إضافة مستمع لانتهاء الفيديو قبل تشغيله
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context); // إغلاق الـ Dialog بعد انتهاء الفيديو
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen5()),
        );
      }
    });

    // بدء تشغيل الفيديو تلقائيًا
    _controller.play();

    // عرض الفيديو بملء الشاشة بدون حدود سوداء
    await showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق الـ Dialog قبل انتهاء الفيديو
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.all(0),
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        );
      },
    );
  }
}
