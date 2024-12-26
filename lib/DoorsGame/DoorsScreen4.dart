import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen5.dart';
import 'stage.dart'; // استدعاء كلاس Stage
import 'SoundManager.dart'; // استدعاء كلاس SoundManager
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'afterdoor4.dart';

class DoorsScreen4 extends StatefulWidget {
  @override
  _DoorsScreen4State createState() => _DoorsScreen4State();
}

class _DoorsScreen4State extends State<DoorsScreen4> {
  late VideoPlayerController _controller;
  final int currentStep = 4; // This is step 4
  final SoundManager soundManager = SoundManager(); // Instance of SoundManager

  @override
  void dispose() {
    _controller.dispose();
    soundManager.dispose(); // تأكد من التخلص من الصوت عند إغلاق الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ضبط الصورة لتغطي كامل الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/doors.png',
              fit: BoxFit.cover, // جعل الصورة تغطي كامل المساحة
            ),
          ),
          //......................
          Positioned(
            top: 10.h, // Position it at the top of the screen
            left: 20.w,
            right: 20.w,
            child: Stack(
              alignment: Alignment
                  .center, // Align the stage name inside the progress bar
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                      20.r)), // Rounded corners for progress bar
                  child: LinearProgressIndicator(
                    value: currentStep / 10, // The progress (1 out of 10 steps)
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      currentStep == 1
                          ? const Color.fromARGB(
                              255, 20, 141, 240) // Color for current step
                          : const Color.fromARGB(
                              255, 172, 156, 13), // Color for other steps
                    ),
                    minHeight: 15.h, // Adjust the height of the progress bar
                  ),
                ),
                Stage(
                  stageName: "المرحلة الرابعة",
                  fontSize: 13,
                )
                // Stage name text overlayed on the progress bar
              ],
            ),
          ),
          //.......................
          // الأبواب القابلة للضغط مع خلفية خلف النصوص
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDoor(context, 'تحميل الملفات من مواقع غير معروفة', false),
                _buildDoor(context, 'تنزيل تطبيقات جديدة لحل المشكلة', false),
                _buildDoor(
                    context,
                    '    إغلاق جميع التطبيقات أو البرامج المفتوحة',
                    true), // Correct answer triggers door4.mp4
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoor(BuildContext context, String label, bool isCorrect) {
    double baseWidth = 375; // The width you designed for, you can adjust this.
    double scaleFactor = MediaQuery.of(context).size.width / baseWidth;

    return GestureDetector(
      onTap: () {
        if (isCorrect) {
          _playVideoAndNavigate(context);
        } else {
          soundManager.playErrorSound();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خاطئ! $label ليس الخيار الصحيح.')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 0.h), // رفع النص قليلاً
          Container(
            width: 110.w, // Adjust the width to match the door size
            height: 30.h, // Adjust height to give more space for the text
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
            alignment: Alignment.center, // Center the text inside the container
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 229, 130, 8)
                  .withOpacity(0.6), // خلفية شبه شفافة
              borderRadius: BorderRadius.circular(80.r),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center, // Center the text horizontally
              style: TextStyle(
                fontSize: 11.sp, // Use ScreenUtil to scale font size
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
        'assets/door1.mp4'); // Updated to play door4.mp4

    try {
      await _controller.initialize();
      // إضافة مستمع لانتهاء الفيديو قبل تشغيله
      _controller.addListener(() {
        if (_controller.value.position == _controller.value.duration) {
          Navigator.pop(context); // إغلاق الـ Dialog بعد انتهاء الفيديو
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DesktopScreen4()),
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
