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

  // Function to move character left, right, forward, or backward
  void _moveCharacter(String direction) {
    setState(() {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      // Set step sizes to match letter spacing
      double moveDistanceX = screenWidth * 0.06; // Horizontal step size
      double moveDistanceY = screenHeight * 0.04; // Vertical step size

      // Update movement constraints
      if (direction == 'left' && _characterXPosition > -screenWidth / 2) {
        _characterXPosition -= moveDistanceX;
        _characterDirection = 'LeftChar.png';
      } else if (direction == 'right' &&
          _characterXPosition < screenWidth / 2) {
        _characterXPosition += moveDistanceX;
        _characterDirection = 'RightChar.png';
      } else if (direction == 'forward' &&
          _characterYPosition < screenHeight / 2) {
        _characterYPosition += moveDistanceY;
        _characterDirection = 'TopChar.png';
      } else if (direction == 'backward' &&
          _characterYPosition > -screenHeight / 2) {
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

    return Scaffold(
      body: Stack(
        children: [
          GameGround(
            characterXPosition: _characterXPosition,
            characterYPosition: _characterYPosition,
            characterDirection: _characterDirection,
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
                  onPressed: () => _moveCharacter('forward'),
                  iconSize: iconSize,
                  padding: buttonPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Arrow
                    ArrowButton(
                      icon: Icons.arrow_back,
                      onPressed: () => _moveCharacter('right'),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),
                    SizedBox(width: buttonPadding),
                    ArrowButton(
                      icon: Icons.arrow_forward,
                      onPressed: () => _moveCharacter('left'),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),

                    // Right Arrow
                  ],
                ),
                // Down Arrow
                ArrowButton(
                  icon: Icons.arrow_downward,
                  onPressed: () => _moveCharacter('backward'),
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
  final VoidCallback onPressed;
  final double iconSize;
  final double padding;

  ArrowButton({
    required this.icon,
    required this.onPressed,
    required this.iconSize,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onPressed: onPressed,
        iconSize: iconSize,
        padding: EdgeInsets.all(padding),
      ),
    );
  }
}
