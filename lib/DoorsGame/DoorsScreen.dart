import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen2.dart';
import 'stage.dart'; // استدعاء Stage class
import 'SoundManager.dart'; // استدعاء SoundManager class
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'DoorImageScreen.dart';

class DoorsScreen extends StatelessWidget {
  final int currentStep = 1; // المرحلة الحالية هي 1 من 10
  final Stage currentStage = Stage(
      stageName:
          "المرحلة 1"); // لا حاجة لذكر الخصائص هنا، سيتم توريث الخصائص الافتراضية
  final SoundManager soundManager =
      SoundManager(); // إنشاء instance من SoundManager

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الصورة الخلفية تغطي الشاشة بالكامل
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset('assets/doors.png'),
            ),
          ),
          // Progress bar with stage name
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
                  stageName: "المرحلة الاولى",
                  fontSize: 13,
                )
                // Stage name text overlayed on the progress bar
              ],
            ),
          ),
          // الأبواب التفاعلية مع النصوص
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
      ),
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
          soundManager
              .playErrorSound(); // تشغيل صوت الخطأ عند اختيار الإجابة الخاطئة
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label تم الضغط عليه')),
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
    _controller = VideoPlayerController.asset('assets/door3.mp4')
      ..initialize().then((_) {
        // Start the video automatically
        _controller.play();
        setState(() {});
      })
      ..setLooping(false);

    // Navigate to the next screen when the video ends
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          //نقل الى الفيديو التالي
          MaterialPageRoute(builder: (context) => DoorImageScreen()),
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
              // لتغطية الشاشة بالكامل
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()), // عرض مؤشر التحميل
    );
  }
}
