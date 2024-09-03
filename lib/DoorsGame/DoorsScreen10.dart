import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class DoorsScreen10 extends StatefulWidget {
  @override
  _DoorsScreen10State createState() => _DoorsScreen10State();
}

class _DoorsScreen10State extends State<DoorsScreen10> {
  final int currentStep = 10; // This is step 10

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40), // Space before the progress bar
          // Progress bar with rounded corners
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(20)), // Rounded corners
              child: LinearProgressIndicator(
                value: currentStep / 10, // The progress (10 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue, // The current step is always blue
                ),
                minHeight: 20, // Increase the height of the progress bar
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Background image covering the full screen
                Positioned.fill(
                  child: Image.asset(
                    'assets/doors.png',
                    fit: BoxFit
                        .cover, // Make sure the image covers the entire screen
                  ),
                ),
                // Interactive doors with text
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDoor(
                          context, 'إنهاء الاتصال', true), // Correct answer
                      _buildDoor(context, 'الرد مرة أخرى', false),
                      _buildDoor(context, 'معالجة الرد', false),
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
          _showWinDialog(); // Show winning dialog
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خاطئ! $label ليس الخيار الصحيح.')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150), // Adjust to lift the text slightly
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
