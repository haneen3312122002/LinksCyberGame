import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'Adues.dart';

class VideoGame extends StatefulWidget {
  @override
  _VideoGameState createState() => _VideoGameState();
}

class _VideoGameState extends State<VideoGame> {
  late VideoPlayerController _streetController;
  late VideoPlayerController _charController;
  bool _isButtonPressed = false;
  double _charPosX = 0.0;
  Obstacle? _currentObstacle;
  final Random _random = Random();
  Timer? _obstacleTimer;
  Timer? _movementTimer;
  bool _isCollision = false;

  @override
  void initState() {
    super.initState();

    // Initialize the street video controller
    _streetController = VideoPlayerController.asset('assets/Street.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    // Automatically replay the street video when it finishes
    _streetController.addListener(() {
      if (_streetController.value.position >=
          _streetController.value.duration) {
        _streetController.seekTo(Duration.zero);
        _streetController.play();
      }
    });

    // Initialize the character video controller
    _charController = VideoPlayerController.asset('assets/MoveChar.webm')
      ..initialize().then((_) {
        setState(() {});
      });

    // Automatically replay the character video when it finishes
    _charController.addListener(() {
      if (_charController.value.position >= _charController.value.duration) {
        _charController.seekTo(Duration.zero);
        _charController.play();
      }
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _charController.dispose();
    _obstacleTimer?.cancel();
    _movementTimer?.cancel();
    super.dispose();
  }

  void _startObstacleTimer() {
    int randomSeconds =
        _random.nextInt(3) + 2; // Random time between 2 to 5 seconds
    _obstacleTimer = Timer(Duration(seconds: randomSeconds), () {
      if (!_isCollision && _currentObstacle == null && _isButtonPressed) {
        _addObstacle();
      }
    });
  }

  void _addObstacle() {
    setState(() {
      // Only add an obstacle if there isn't one already
      int randomInt = _random.nextInt(2); // Generates 0 or 1
      String obstacleType = randomInt == 0 ? 'HttpsStop.gif' : 'HttpStop.gif';
      print('Random int: $randomInt, Obstacle: $obstacleType');
      _currentObstacle = Obstacle(
        type: 'assets/$obstacleType',
        xPosition: (MediaQuery.of(context).size.width - 400) /
            2, // Centered horizontally
        yPosition: 0, // Start from the top
      );
    });
    //play stop audio:
    AudioPlayerManager.playStopSound();
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
    setState(() {
      _isButtonPressed = true;
      _isCollision = false; // Ensure collision is false
    });

    // Start the movement timer
    _startMovementTimer();

    // Start the obstacle timer
    _startObstacleTimer();
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
    setState(() {
      _isButtonPressed = false;
      _currentObstacle = null; // Remove any obstacle
    });

    // Stop the movement timer
    _movementTimer?.cancel();

    // Stop the obstacle timer
    _obstacleTimer?.cancel();
  }

  void _startMovementTimer() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (_isButtonPressed && !_isCollision) {
        if (_currentObstacle != null) {
          setState(() {
            _currentObstacle!.yPosition += 5; // Move the obstacle down
          });
          _checkCollision(); // Check collision with character
        }
      }
    });
  }

  void _checkCollision() {
    if (_currentObstacle != null) {
      double charLeft =
          (MediaQuery.of(context).size.width - 150) / 2 + _charPosX;
      double charRight = charLeft + 150; // Character width
      double obstacleLeft = _currentObstacle!.xPosition;
      double obstacleRight = obstacleLeft + 400; // Obstacle width
      double obstacleTop = _currentObstacle!.yPosition;
      double obstacleBottom = obstacleTop + 400; // Obstacle height

      if (charRight > obstacleLeft &&
          charLeft < obstacleRight &&
          obstacleBottom > 240 && // Character's top position
          obstacleTop < 240 + 250) {
        // Character's bottom position
        // Collision detected
        setState(() {
          _isCollision = true;
          _streetController.pause();
          _charController.pause();
          _isButtonPressed = false;
          _movementTimer?.cancel();
          _obstacleTimer?.cancel();
        });
      }
    }
  }

  void _onObstacleTap() {
    setState(() {
      _currentObstacle = null;
      _isCollision = false;
      // Do not resume movement automatically
      // User needs to press the arrow button again to resume movement
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            // Display the street video
            _streetController.value.isInitialized
                ? SizedBox(
                    width: screenSize.width,
                    height: screenSize.height,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _streetController.value.size.width,
                        height: _streetController.value.size.height,
                        child: VideoPlayer(_streetController),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),

            // Display the obstacle if present
            if (_currentObstacle != null)
              Positioned(
                left: _currentObstacle!.xPosition,
                top: _currentObstacle!.yPosition,
                child: GestureDetector(
                  onTap: _onObstacleTap,
                  child: Image.asset(
                    _currentObstacle!.type,
                    width: 400,
                    height: 400,
                  ),
                ),
              ),

            // Display the character
            _charController.value.isInitialized
                ? Positioned(
                    top: 240,
                    left: (screenSize.width - 150) / 2 + _charPosX,
                    child: SizedBox(
                      width: 150,
                      height: 250,
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
                    Icons.arrow_upward,
                    size: 60.0,
                    color: _isButtonPressed ? Colors.red : Colors.white,
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

class Obstacle {
  String type;
  double xPosition;
  double yPosition;

  Obstacle({
    required this.type,
    required this.xPosition,
    required this.yPosition,
  });
}
