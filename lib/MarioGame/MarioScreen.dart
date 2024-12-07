import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Adding this line
import 'package:http/http.dart' as http; // For API calls
import 'package:cybergame/connection.dart';
import 'MovingBack.dart';
import 'MarioBackground.dart';

class MarioGameScreen extends StatefulWidget {
  @override
  _MarioGameScreenState createState() => _MarioGameScreenState();
}

class _MarioGameScreenState extends State<MarioGameScreen> {
  double _characterXPosition =
      0; // Initial horizontal position of the character
  double _characterYPosition = 0.0; // Start at the bottom
  String _characterDirection = 'assets/TopChar.png'; // Initial character image
  Timer? _movementTimer; // Timer for continuous movement
  String _randomWord = ""; // Variable to hold the random word
  int _randomKey = 0; // Variable to hold the random key
  List<String> _collectedLetters = []; // List to hold collected letters
  String? _apiResult; // Variable to hold API result

  String?
      _currentLetter; // Variable to hold the current letter the character is standing on

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

      double characterWidth = 120.0;
      double characterHeight = 120.0;

      // Update movement based on direction
      if (direction == 'left' && _characterXPosition > -screenWidth / 2) {
        _characterXPosition -= moveDistanceX;
        _characterDirection = 'assets/LeftChar.png';
      } else if (direction == 'right' &&
          _characterXPosition < screenWidth / 2 - characterWidth) {
        _characterXPosition += moveDistanceX;
        _characterDirection = 'assets/RightChar.png';
      } else if (direction == 'forward' &&
          _characterYPosition < screenHeight - characterHeight) {
        _characterYPosition += moveDistanceY;
        _characterDirection = 'assets/TopChar.png';
      } else if (direction == 'backward' && _characterYPosition > 0) {
        _characterYPosition -= moveDistanceY;
        _characterDirection = 'assets/DownChar.png';
      }

      // After moving, check for letter
      List<LetterTileData> letterTiles = _generateLetterTiles(context);
      _checkForLetter(context, letterTiles);
    });
  }

  // Method to generate letter tiles with positions
  List<LetterTileData> _generateLetterTiles(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    List<LetterTileData> letterTiles = [];

    // Letters A-M on the central vertical street (bottom to top)
    for (int index = 0; index < 13; index++) {
      final letter = String.fromCharCode(65 + index); // A to M
      if (!_collectedLetters.contains(letter)) {
        final x = screenWidth / 2 - 15;

        // Adjust the y-coordinate to be consistent with the character’s expected height range
        final y = (screenHeight / 14) * index + 30;

        letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
      }
    }

    // Letters N-T on the left horizontal street, centered vertically
    for (int index = 0; index < 7; index++) {
      final letter = String.fromCharCode(78 + index); // N to T
      if (!_collectedLetters.contains(letter)) {
        final x = (screenWidth / 14) * index + 20;
        final y = (screenHeight / 2) - 40 + (80 / 2) - 15;
        letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
      }
    }

    // Letters U-Z on the right horizontal street, centered vertically
    for (int index = 0; index < 6; index++) {
      final letter = String.fromCharCode(85 + index); // U to Z
      if (!_collectedLetters.contains(letter)) {
        final x = screenWidth / 2 + (index * (screenWidth / 14)) + 40;
        final y = (screenHeight / 2) - 40 + (80 / 2) - 15;
        letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
      }
    }

    return letterTiles;
  }

  // Method to check for collision with letters
  void _checkForLetter(BuildContext context, List<LetterTileData> letterTiles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Character dimensions
    double characterWidth = 120;
    double characterHeight = 120;

    // Calculate character's position
    double characterLeft = (screenWidth / 2) + _characterXPosition - 25;
    double characterBottom = _characterYPosition;

    // Create character rectangle to use as the hitbox
    Rect characterRect = Rect.fromLTWH(
      characterLeft,
      screenHeight - characterBottom - characterHeight,
      characterWidth,
      characterHeight,
    );

    bool found = false;

    for (LetterTileData tile in letterTiles) {
      double tileLeft = tile.x;
      double tileBottom = tile.y;

      // Define a threshold based on whether the letter is on the vertical street
      bool isVerticalTile =
          (tileLeft > screenWidth / 2 - 40 && tileLeft < screenWidth / 2 + 40);
      double thresholdX =
          isVerticalTile ? 5.0 : 2.0; // Adjusted for vertical sensitivity
      double thresholdY =
          isVerticalTile ? 20.0 : 5.0; // More lenient for vertical alignment

      // Expand the tile's hitbox based on the thresholds
      Rect tileRect = Rect.fromLTWH(
        tileLeft - thresholdX,
        screenHeight - tileBottom - 30 - thresholdY,
        30 + 2 * thresholdX,
        30 + 2 * thresholdY,
      );

      // Calculate centers of character and tile
      Offset characterCenter = characterRect.center;
      Offset tileCenter = tileRect.center;

      // Check if the character's center is within close proximity of the tile's center
      if ((characterCenter - tileCenter).distance <= 30) {
        // Adjust the distance threshold as needed
        setState(() {
          _currentLetter = tile.letter; // Set the current letter
        });
        found = true;
        break; // Exit loop after finding the first exact collision
      }
    }

    if (!found) {
      setState(() {
        _currentLetter = null; // No letter under character
      });
    }
  }

  // Function to collect the current letter
  void _collectCurrentLetter() {
    if (_currentLetter != null && !_collectedLetters.contains(_currentLetter)) {
      setState(() {
        _collectedLetters.add(_currentLetter!); // Add to end of list
        _currentLetter = null; // Reset current letter after collecting
      });
    }
  }

  // Function to display the collected word
  void _displayCollectedWord() {
    String collectedWord = _collectedLetters.join();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Collected Word'),
          content: Text(
            collectedWord.isNotEmpty ? collectedWord : 'No letters collected.',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to submit the collected word to the API
  void _submitWord() async {
    final String collectedWord = _collectedLetters.join().toLowerCase();
    final String displayedWord = _randomWord.toLowerCase();
    final int key = _randomKey;

    try {
      bool result = await MarioApiService.compareWord(
        collectedWord: collectedWord,
        displayedWord: displayedWord,
        key: key,
      );

      setState(() {
        _apiResult = result ? 'Correct!' : 'Incorrect!';
      });
    } catch (e) {
      // Handle errors from the ApiService
      setState(() {
        _apiResult = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize =
        MediaQuery.of(context).size.width * 0.03; // Adjusted icon size
    double buttonPadding = MediaQuery.of(context).size.width * 0.01;
    double fontSize = MediaQuery.of(context).size.width * 0.04;

    // Generate the letter tiles
    List<LetterTileData> letterTiles = _generateLetterTiles(context);

    return Scaffold(
      body: Stack(
        children: [
          MarioBackground(),
          GameGround(
            characterXPosition: _characterXPosition,
            characterYPosition: _characterYPosition,
            characterDirection: _characterDirection,
            letterTiles: letterTiles,
          ),
          // Display the random word at the top left corner with fun styling
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              _randomWord,
              style: GoogleFonts.pangolin(
                // Using font from the library
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple, // Use a fun color
                ),
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
                  style: GoogleFonts.pangolin(
                    // Using font from the library
                    textStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Display the current letter at the top center
          if (_currentLetter != null)
            Positioned(
              top: 60,
              left: MediaQuery.of(context).size.width / 2 - fontSize * 2,
              child: Text(
                'Current Letter: $_currentLetter',
                style: GoogleFonts.pangolin(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
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
          // Buttons and collected letters at the bottom left
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buttons Row
                Row(
                  children: [
                    // Display Collected Word Button
                    ElevatedButton(
                      onPressed: _displayCollectedWord,
                      child: Text('Display Word'),
                    ),
                    SizedBox(width: 10),
                    // Collect Letter Button
                    ElevatedButton(
                      onPressed:
                          _currentLetter != null ? _collectCurrentLetter : null,
                      child: Text('Collect Letter'),
                    ),
                    SizedBox(width: 10),
                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitWord,
                      child: Text('Submit'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Display collected letters from left to right
                Row(
                  children: _collectedLetters.map((letter) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 187, 67, 127),
                        border: Border.all(
                            color: const Color.fromARGB(255, 51, 5, 37)),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        letter,
                        style: GoogleFonts.pangolin(
                          // Using font from the library
                          textStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 14, 12, 12),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Display API result in the center of the screen
          if (_apiResult != null)
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white.withOpacity(0.8),
                child: Text(
                  _apiResult!,
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
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

// Additional classes (MarioBackground, GameGround) should be included here if needed
