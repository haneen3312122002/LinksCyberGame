import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'MovingBack.dart';

class MarioGameScreen extends StatefulWidget {
  @override
  _MarioGameScreenState createState() => _MarioGameScreenState();
}

class _MarioGameScreenState extends State<MarioGameScreen> {
  double _characterXPosition =
      0; // Initial horizontal position of the character
  double _characterYPosition =
      0.05; // Initial vertical position relative to screen height
  String _characterDirection = 'TopChar.png'; // Initial character image
  Timer? _movementTimer; // Timer for continuous movement
  String _randomWord = ""; // Variable to hold the random word
  int _randomKey = 0; // Variable to hold the random key

  // List of three-character words
  final List<String> _words = ["cat", "dog", "sun", "car", "bat", "hat", "map"];

  @override
  void initState() {
    super.initState();
    _generateRandomWordAndKey(); // Generate a random word and key at the start of the game
  }

  // Function to generate a random word and key
  void _generateRandomWordAndKey() {
    final random = Random();
    setState(() {
      _randomWord = _words[random.nextInt(_words.length)];
      _randomKey = random.nextInt(10) + 1; // Random key between 1 and 10
    });
  }

  // Function to start moving character in a specific direction continuously
  void _startMoving(String direction) {
    _movementTimer?.cancel(); // Cancel any existing timer
    _movementTimer = Timer.periodic(Duration(milliseconds: 16), (_) {
      _moveCharacter(
          direction); // Repeated move at high frequency for smoothness
    });
  }

  // Function to stop continuous movement
  void _stopMoving() {
    _movementTimer?.cancel();
    _movementTimer = null;
  }

  // Function to move character left, right, forward, or backward
  void _moveCharacter(String direction) {
    setState(() {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // Smaller step sizes for smoother movement
      double moveDistanceX = screenWidth * 0.005; // Horizontal step size
      double moveDistanceY = screenHeight * 0.005; // Vertical step size

      // Update movement based on direction
      if (direction == 'left' && _characterXPosition > -screenWidth / 2) {
        _characterXPosition -= moveDistanceX;
        _characterDirection = 'LeftChar.png';
      } else if (direction == 'right' &&
          _characterXPosition < screenWidth / 2) {
        _characterXPosition += moveDistanceX;
        _characterDirection = 'RightChar.png';
      } else if (direction == 'forward' &&
          _characterYPosition < screenHeight / 3) {
        _characterYPosition += moveDistanceY;
        _characterDirection = 'TopChar.png';
      } else if (direction == 'backward' &&
          _characterYPosition > -screenHeight / 3) {
        _characterYPosition -= moveDistanceY;
        _characterDirection = 'DownChar.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize =
        MediaQuery.of(context).size.width * 0.02; // Arrow button size
    double buttonPadding = MediaQuery.of(context).size.width * 0.01;
    double fontSize = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      body: Stack(
        children: [
          GameGround(
            characterXPosition: _characterXPosition,
            characterYPosition: _characterYPosition,
            characterDirection: _characterDirection,
          ),
          // Display the random word at the top left corner with fun styling
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              _randomWord,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.purple, // Use a fun color
                fontFamily: 'Comic Sans MS', // Apply a playful font style
              ),
            ),
          ),
          // Display the random key with a key icon on the top right corner
          Positioned(
            top: 60,
            right: 20,
            child: Row(
              children: [
                Icon(Icons.vpn_key,
                    color: Colors.orange, size: fontSize * 0.8), // Key icon
                SizedBox(width: 5),
                Text(
                  '$_randomKey',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontFamily: 'Comic Sans MS', // Match the fun style
                  ),
                ),
              ],
            ),
          ),
          // Control buttons arranged in a diamond shape
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Column(
              children: [
                // Up Arrow
                ArrowButton(
                  icon: Icons.arrow_upward,
                  onTapDown: (_) => _startMoving('forward'),
                  onTapUp: (_) => _stopMoving(),
                  onTapCancel: () => _stopMoving(),
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Arrow
                    ArrowButton(
                      icon: Icons.arrow_back,
                      onTapDown: (_) => _startMoving('right'),
                      onTapUp: (_) => _stopMoving(),
                      onTapCancel: () => _stopMoving(),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),
                    SizedBox(width: buttonPadding),
                    ArrowButton(
                      icon: Icons.arrow_forward,
                      onTapDown: (_) => _startMoving('left'),
                      onTapUp: (_) => _stopMoving(),
                      onTapCancel: () => _stopMoving(),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),
                    // Right Arrow
                  ],
                ),
                // Down Arrow
                ArrowButton(
                  icon: Icons.arrow_downward,
                  onTapDown: (_) => _startMoving('backward'),
                  onTapUp: (_) => _stopMoving(),
                  onTapCancel: () => _stopMoving(),
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to create a styled arrow button with responsive sizing
class ArrowButton extends StatelessWidget {
  final IconData icon;
  final GestureTapDownCallback onTapDown;
  final GestureTapUpCallback onTapUp;
  final GestureTapCancelCallback onTapCancel;
  final double iconSize;
  final double padding;

  ArrowButton({
    required this.icon,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.iconSize,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 100, 180, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: () {}, // Required by IconButton but unused here
          iconSize: iconSize,
          padding: EdgeInsets.all(padding),
        ),
      ),
    );
  }
}
