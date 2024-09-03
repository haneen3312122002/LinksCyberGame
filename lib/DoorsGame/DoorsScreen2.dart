import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen3.dart';

class DoorsScreen2 extends StatefulWidget {
  @override
  _DoorsScreen2State createState() => _DoorsScreen2State();
}

class _DoorsScreen2State extends State<DoorsScreen2> {
  late VideoPlayerController _controller;
  final int currentStep = 2; // This is step 2

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                value: currentStep / 10, // The progress (2 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 2
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
                      _buildDoor(context, 'إنهاء الاتصال', false),
                      _buildDoor(context, 'تحديد عنوان URL',
                          true), // Correct answer triggers door2.mp4
                      _buildDoor(context, 'تحديد نوع الطلب', false),
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
    _controller = VideoPlayerController.asset('assets/door2.mp4');
    await _controller.initialize();

    // إضافة مستمع لانتهاء الفيديو قبل تشغيله
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context); // إغلاق الـ Dialog بعد انتهاء الفيديو
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen3()),
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
