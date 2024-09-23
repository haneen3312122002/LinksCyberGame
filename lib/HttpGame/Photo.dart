import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGame extends StatefulWidget {
  @override
  _VideoGameState createState() => _VideoGameState();
}

class _VideoGameState extends State<VideoGame> {
  late VideoPlayerController
      _streetController; // Controller for the street video
  late VideoPlayerController
      _charController; // Controller for the character video
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    // Initialize the street video controller
    _streetController = VideoPlayerController.asset('assets/Street.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI when the video is initialized
      });

    // Automatically replay the street video when it finishes
    _streetController.addListener(() {
      if (_streetController.value.position ==
          _streetController.value.duration) {
        _streetController.seekTo(Duration.zero);
        _streetController.play();
      }
    });

    // Initialize the character video controller
    _charController = VideoPlayerController.asset('assets/MoveChar.webm')
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI when the video is initialized
      });

    // Automatically replay the character video when it finishes
    _charController.addListener(() {
      if (_charController.value.position == _charController.value.duration) {
        _charController.seekTo(Duration.zero);
        _charController.play();
      }
    });
  }

  @override
  void dispose() {
    _streetController
        .dispose(); // Dispose of controllers when the widget is removed
    _charController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    if (_streetController.value.isInitialized &&
        !_streetController.value.isPlaying) {
      _streetController.play();
    }
    if (_charController.value.isInitialized &&
        !_charController.value.isPlaying) {
      _charController.play();
    }
    setState(() => _isButtonPressed = true);
  }

  void _onButtonReleased() {
    if (_streetController.value.isInitialized &&
        _streetController.value.isPlaying) {
      _streetController.pause();
    }
    if (_charController.value.isInitialized &&
        _charController.value.isPlaying) {
      _charController.pause();
    }
    setState(() => _isButtonPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            // Display the street video if it's initialized, otherwise show a loading indicator
            _streetController.value.isInitialized
                ? SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: FittedBox(
                      fit: BoxFit
                          .cover, // Cover the entire screen with the street video
                      child: SizedBox(
                        width: _streetController.value.size.width,
                        height: _streetController.value.size.height,
                        child: VideoPlayer(_streetController),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),

            // Display the character video at the bottom center of the screen
            _charController.value.isInitialized
                ? Positioned(
                    bottom:
                        0, // Adjust this value to place the character at the correct height from the bottom
                    left: (screenWidth - 150) / 2, // Center horizontally
                    child: SizedBox(
                      width: 150, // Width of the character video
                      height: 250, // Height of the character video
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _charController.value.size.width,
                          height: _charController.value.size.height,
                          child: VideoPlayer(_charController),
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),

            // Positioned upward arrow icon at the bottom left
            Positioned(
              bottom: 20,
              left: 20,
              child: GestureDetector(
                onTapDown: (_) => _onButtonPressed(),
                onTapUp: (_) => _onButtonReleased(),
                onTapCancel: () => _onButtonReleased(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.cyanAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.arrow_upward, // Upward arrow icon
                    size: 60.0, // Set icon size
                    color: _isButtonPressed
                        ? Colors.red
                        : Colors.white, // Change color based on state
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
