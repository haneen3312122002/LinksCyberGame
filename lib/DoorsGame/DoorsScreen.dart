import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'DoorsScreen2.dart';

class DoorsScreen extends StatelessWidget {
  final int currentStep = 1; // Example: Current step is 1 (out of 10)

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
                value: currentStep / 10, // The progress (1 out of 10 steps)
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  currentStep == 1
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
                // Background image covering the full screen
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/doors.png'),
                  ),
                ),
                // Interactive doors with text
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDoor(context, 'اختيار البروتوكول',
                          isCorrect: true), // Correct door
                      _buildDoor(context, 'اضافة بيانات الطلب',
                          isCorrect: false),
                      _buildDoor(context, 'ارسال الطلب', isCorrect: false),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label تم الضغط عليه')),
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
              color: const Color.fromARGB(255, 229, 130, 8)
                  .withOpacity(0.6), // Semi-transparent background
              borderRadius: BorderRadius.circular(80),
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
    _controller = VideoPlayerController.asset('assets/door1.mp4')
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
          MaterialPageRoute(builder: (context) => DoorsScreen2()),
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
              // To cover the entire screen
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
