import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen5.dart';

class DoorsScreen4 extends StatefulWidget {
  @override
  _DoorsScreen4State createState() => _DoorsScreen4State();
}

class _DoorsScreen4State extends State<DoorsScreen4> {
  late VideoPlayerController _controller;
  final int currentStep = 4; // This is step 4

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
                value: currentStep / 10, // The progress (4 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 4
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
                      _buildDoor(context, 'انتظار الرد', false),
                      _buildDoor(context, 'اختيار بروتوكول', false),
                      _buildDoor(context, 'اعداد الرؤوس',
                          true), // Correct answer triggers door4.mp4
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
    _controller = VideoPlayerController.asset('assets/door3.mp4');

    try {
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
    } catch (e) {
      // Handle any errors during video initialization or playback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play video: $e')),
      );
    }
  }
}
