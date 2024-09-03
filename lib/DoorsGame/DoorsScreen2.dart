import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen3.dart';

class DoorsScreen2 extends StatefulWidget {
  @override
  _DoorsScreen2State createState() => _DoorsScreen2State();
}

class _DoorsScreen2State extends State<DoorsScreen2> {
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
              _buildDoor(context, 'إنهاء الاتصال', false),
              _buildDoor(context, 'تحديد عنوان URL', true),
              _buildDoor(context, 'تحديد نوع الطلب', false),
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
          // تشغيل الفيديو بملء الشاشة عند اختيار الإجابة الصحيحة
          _playVideoAndNavigate(context);
        } else {
          // تنفيذ الأكشن المناسب عند اختيار خيار خاطئ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خاطئ! $label ليس الخيار الصحيح.')),
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

    // عرض فيديو فقط بعد التهيئة الكاملة باستخدام FutureBuilder
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder(
            future: _controller.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // إذا تم تهيئة الفيديو، قم بعرضه
                _controller.play();
                _controller.addListener(() {
                  if (_controller.value.position ==
                      _controller.value.duration) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DoorsScreen3()),
                    );
                  }
                });
                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                );
              } else {
                // أثناء التهيئة، اعرض مؤشر تحميل
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
