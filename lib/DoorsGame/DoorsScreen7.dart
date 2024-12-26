import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'afterdoor7.dart'; // تأكد من تعريف DoorsScreen8 بشكل صحيح
import 'stage.dart'; // استدعاء كلاس Stage
import 'SoundManager.dart'; // استدعاء كلاس SoundManager
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoorsScreen7 extends StatefulWidget {
  @override
  _DoorsScreen7State createState() => _DoorsScreen7State();
}

class _DoorsScreen7State extends State<DoorsScreen7> {
  late VideoPlayerController _controller;
  final int currentStep = 7; // This is step 7
  final SoundManager soundManager = SoundManager(); // Instance of SoundManager

  @override
  void dispose() {
    _controller.dispose();
    soundManager.dispose(); // Dispose sound resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image covering the full screen
          Positioned.fill(
            child: Image.asset(
              'assets/doors.png',
              fit: BoxFit.cover, // Ensure the image covers the full screen
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
                  stageName: "المرحلة السابعة",
                  fontSize: 13,
                  textColor: Colors.white,
                )
                // Stage name text overlayed on the progress bar
              ],
            ),
          ),
          //.......................
          // Interactive doors with text
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDoor(
                    context, 'إعادة تشغيل الجهاز', true), // Correct answer
                _buildDoor(context, 'ترك الجهاز مغلقًا لمدة يومين', false),
                _buildDoor(context, 'عدم استخدام الجهاز مرة أخرى', false),
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
              context); // Play video and navigate to next screen
        } else {
          soundManager.playErrorSound(); // تشغيل صوت الخطأ عند الإجابة الخاطئة
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
    _controller =
        VideoPlayerController.asset('assets/door3.mp4'); // Play door1.mp4
    await _controller.initialize();

    // Listener to handle end of video playback
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context); // Close the dialog after the video ends
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DesktopScreen7()),
        );
      }
    });

    // Start playing the video automatically
    _controller.play();

    // Display the video in full screen
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog before video ends
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
