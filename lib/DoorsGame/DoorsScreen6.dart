import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen7.dart'; // Make sure this screen is properly defined

class DoorsScreen6 extends StatefulWidget {
  @override
  _DoorsScreen6State createState() => _DoorsScreen6State();
}

class _DoorsScreen6State extends State<DoorsScreen6> {
  late VideoPlayerController _controller;
  final int currentStep = 6; // This is step 6

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
          SizedBox(height: 40), // Space before the progress bar
          // Progress bar with rounded corners
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(20)), // Rounded corners
              child: LinearProgressIndicator(
                value: currentStep / 10, // The progress (6 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 6
                      ? Colors.blue // Set the color of the current step to blue
                      : Colors.yellow, // Future steps will stay yellow
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
                      _buildDoor(context, 'انتظار الرد', false),
                      _buildDoor(context, 'تحديد نوع الطلب', false),
                      _buildDoor(
                          context, 'إرسال الطلب', true), // Correct answer
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
              context); // Play video and navigate to next screen
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
    _controller =
        VideoPlayerController.asset('assets/door3.mp4'); // Play door3.mp4
    await _controller.initialize();

    // Listener to handle end of video playback
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        Navigator.pop(context); // Close the dialog after the video ends
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoorsScreen7()),
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
