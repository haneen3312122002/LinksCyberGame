import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'stage.dart'; // استدعاء كلاس Stage
import 'SoundManager.dart'; // استدعاء كلاس SoundManager
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoorsScreen10 extends StatefulWidget {
  @override
  _DoorsScreen10State createState() => _DoorsScreen10State();
}

class _DoorsScreen10State extends State<DoorsScreen10> {
  final int currentStep = 10; // This is step 10
  final SoundManager soundManager = SoundManager(); // Instance of SoundManager

  @override
  void dispose() {
    soundManager.dispose(); // التخلص من الصوت عند إغلاق الشاشة
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
              fit: BoxFit.cover, // Make sure the image covers the entire screen
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
                  stageName: "المرحلة العاشرة",
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
                _buildDoor(context, 'إنهاء الاتصال', true), // Correct answer
                _buildDoor(context, 'الرد مرة أخرى', false),
                _buildDoor(context, 'معالجة الرد', false),
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
          _showWinDialog(); // Show winning dialog
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

  void _showWinDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'تهانينا!',
      desc: 'لقد فزت باللعبة!',
      btnOkOnPress: () {
        // Reset or navigate to another screen
      },
      btnOkText: 'حسنًا',
      btnOkColor: Color.fromARGB(255, 0, 119, 255),
      headerAnimationLoop: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    ).show();
  }
}
