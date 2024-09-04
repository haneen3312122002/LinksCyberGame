import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen4.dart';
import 'stage.dart'; // استدعاء كلاس Stage
import 'SoundManager.dart'; // استدعاء كلاس SoundManager

class DoorsScreen3 extends StatefulWidget {
  @override
  _DoorsScreen3State createState() => _DoorsScreen3State();
}

class _DoorsScreen3State extends State<DoorsScreen3> {
  late VideoPlayerController _controller;
  final int currentStep = 3; // This is step 3
  final SoundManager soundManager =
      SoundManager(); // إنشاء instance من SoundManager

  @override
  void dispose() {
    _controller.dispose();
    soundManager.dispose(); // تأكد من إيقاف تشغيل الصوت عند الخروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // استخدام كلاس Stage لعرض اسم المرحلة في الـ AppBar
        title: Stage(
          stageName: 'المرحلة $currentStep', // عرض اسم المرحلة باستخدام Stage
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
              height: 40), // Add some space at the top before the progress bar
          // Progress bar with rounded corners
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(20)), // Rounded corners
              child: LinearProgressIndicator(
                value: currentStep / 10, // The progress (3 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 3
                      ? Colors.blue // Set the color of the current step to blue
                      : Colors.yellow, // Future steps will stay yellow
                ),
                minHeight:
                    20, // Optional: Increase the height of the progress bar
              ),
            ),
          ),
          Expanded(
            child: Stack(
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
                      _buildDoor(context, 'إضافة بيانات الطلب', false),
                      _buildDoor(context, 'إرسال الطلب', false),
                      _buildDoor(context, 'تحديد نوع الطلب',
                          true), // Correct answer triggers door3.mp4
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoor(BuildContext context, String label, bool isCorrect) {
    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          _playVideoAndNavigate(
              context); // تشغيل الفيديو والانتقال للصفحة التالية
        } else {
          soundManager
              .playErrorSound(); // تشغيل صوت الخطأ عند اختيار الإجابة الخاطئة
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
    _controller = VideoPlayerController.asset(
        'assets/door3.mp4'); // Updated to play door3.mp4
    await _controller.initialize();

    // إضافة مستمع لانتهاء الفيديو قبل تشغيله
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context); // إغلاق الـ Dialog بعد انتهاء الفيديو
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen4()),
        );
      }
    });

    // بدء تشغيل الفيديو تلقائيًا
    _controller.play();

    // عرض الفيديو بملء الشاشة
    await showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق الـ Dialog قبل انتهاء الفيديو
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
