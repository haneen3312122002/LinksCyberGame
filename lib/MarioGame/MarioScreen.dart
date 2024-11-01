import 'package:flutter/material.dart';
import 'MovingBack.dart';

class MarioGameScreen extends StatefulWidget {
  @override
  _MarioGameScreenState createState() => _MarioGameScreenState();
}

class _MarioGameScreenState extends State<MarioGameScreen> {
  double _characterXPosition =
      0; // Initial horizontal position of the character
  double _characterYPosition = 30; // Initial vertical position of the character
  String _characterDirection = 'TopChar.png'; // Initial character image

  // Function to move character left, right, forward, or backward
  void _moveCharacter(String direction) {
    setState(() {
      if (direction == 'left') {
        _characterXPosition -= 40; // Move left
        _characterDirection = 'LeftChar.png';
      } else if (direction == 'right') {
        _characterXPosition += 40; // Move right
        _characterDirection = 'RightChar.png';
      } else if (direction == 'forward') {
        _characterYPosition += 40; // Move upward along the central street
        _characterDirection = 'TopChar.png';
      } else if (direction == 'backward') {
        _characterYPosition -= 40; // Move downward along the central street
        _characterDirection = 'DownChar.png'; // Change to downward image
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            bottom: 70,
            right: 20,
            child: Column(
              children: [
                // Up Arrow
                ArrowButton(
                  icon: Icons.arrow_upward,
                  onPressed: () => _moveCharacter('forward'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Arrow
                    ArrowButton(
                      icon: Icons.arrow_forward,
                      onPressed: () => _moveCharacter('left'),
                    ),
                    SizedBox(width: 10),
                    // Right Arrow
                    ArrowButton(
                      icon: Icons.arrow_back,
                      onPressed: () => _moveCharacter('right'),
                    ),
                  ],
                ),
                // Down Arrow
                ArrowButton(
                  icon: Icons.arrow_downward,
                  onPressed: () => _moveCharacter('backward'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to create a styled arrow button
class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  ArrowButton({required this.icon, required this.onPressed});

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
        iconSize: 30, // Smaller icon size
        padding: EdgeInsets.all(12),
      ),
    );
  }
}
