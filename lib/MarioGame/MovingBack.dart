import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Data class to hold letter tile information
class LetterTileData {
  final String letter;
  final double x;
  final double y;

  LetterTileData({required this.letter, required this.x, required this.y});
}

class MarioGameScreen extends StatefulWidget {
  @override
  _MarioGameScreenState createState() => _MarioGameScreenState();
}

class _MarioGameScreenState extends State<MarioGameScreen> {
  double _characterXPosition = 0;
  double _characterYPosition = 0.0;
  String _characterDirection = 'assets/character_top.png';
  Timer? _movementTimer;
  String _randomWord = "";
  int _randomKey = 0;
  String? _foundLetter;

  final List<String> _words = ["cat", "dog", "sun", "car", "bat", "hat", "map"];

  @override
  void initState() {
    super.initState();
    _generateRandomWordAndKey();
  }

  void _generateRandomWordAndKey() {
    final random = Random();
    setState(() {
      _randomWord = _words[random.nextInt(_words.length)];
      _randomKey = random.nextInt(10) + 1;
    });
  }

  void _startMoving(String direction) {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(Duration(milliseconds: 16), (_) {
      _moveCharacter(direction);
    });
  }

  void _stopMoving() {
    _movementTimer?.cancel();
    _movementTimer = null;
  }

  void _moveCharacter(String direction) {
    setState(() {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      double moveDistanceX = screenWidth * 0.005;
      double moveDistanceY = screenHeight * 0.005;

      double characterWidth = 120.0;
      double characterHeight = 120.0;

      if (direction == 'left' && _characterXPosition > -screenWidth / 2) {
        _characterXPosition -= moveDistanceX;
        _characterDirection = 'assets/character_left.png';
      } else if (direction == 'right' &&
          _characterXPosition < screenWidth / 2 - characterWidth) {
        _characterXPosition += moveDistanceX;
        _characterDirection = 'assets/character_right.png';
      } else if (direction == 'forward' &&
          _characterYPosition < screenHeight - characterHeight) {
        _characterYPosition += moveDistanceY;
        _characterDirection = 'assets/character_top.png';
      } else if (direction == 'backward' && _characterYPosition > 0) {
        _characterYPosition -= moveDistanceY;
        _characterDirection = 'assets/character_down.png';
      }
    });
  }

  List<LetterTileData> _generateLetterTiles(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    List<LetterTileData> letterTiles = [];

    // Letters A-M on the central vertical street
    for (int index = 0; index < 13; index++) {
      final letter = String.fromCharCode(65 + index);
      final x = screenWidth / 2 - 15;
      final y = 30 + (screenHeight / 14) * index;
      letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
    }

    // Letters N-T on the left horizontal street
    for (int index = 0; index < 7; index++) {
      final letter = String.fromCharCode(78 + index);
      final x = (screenWidth / 14) * index + 20;
      final y = (screenHeight / 2) - 40 + (80 / 2) - 15;
      letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
    }

    // Letters U-Z on the right horizontal street
    for (int index = 0; index < 6; index++) {
      final letter = String.fromCharCode(85 + index);
      final x = screenWidth / 2 + (index * (screenWidth / 14)) + 40;
      final y = (screenHeight / 2) - 40 + (80 / 2) - 15;
      letterTiles.add(LetterTileData(letter: letter, x: x, y: y));
    }

    return letterTiles;
  }

  void _checkForLetter(BuildContext context, List<LetterTileData> letterTiles) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double characterWidth = 120;
    double characterHeight = 120;

    double characterLeft = (screenWidth / 2) + _characterXPosition - 25;
    double characterBottom = _characterYPosition;

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

      double tileWidth = 30;
      double tileHeight = 30;

      Rect tileRect = Rect.fromLTWH(
        tileLeft,
        screenHeight - tileBottom - tileHeight,
        tileWidth,
        tileHeight,
      );

      if (characterRect.overlaps(tileRect)) {
        setState(() {
          _foundLetter = tile.letter;
        });
        found = true;
        break;
      }
    }

    if (!found) {
      setState(() {
        _foundLetter = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.08;
    double buttonPadding = MediaQuery.of(context).size.width * 0.01;
    double fontSize = MediaQuery.of(context).size.width * 0.07;

    List<LetterTileData> letterTiles = _generateLetterTiles(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Stack(
        children: [
          GameGround(
            characterXPosition: _characterXPosition,
            characterYPosition: _characterYPosition,
            characterDirection: _characterDirection,
            letterTiles: letterTiles,
          ),
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              _randomWord,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontFamily: 'ComicSans',
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: Row(
              children: [
                Icon(Icons.vpn_key, color: Colors.orange, size: fontSize * 0.8),
                SizedBox(width: 5),
                Text(
                  '$_randomKey',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontFamily: 'ComicSans',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Column(
              children: [
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
                    ArrowButton(
                      icon: Icons.arrow_back,
                      onTapDown: (_) => _startMoving('left'),
                      onTapUp: (_) => _stopMoving(),
                      onTapCancel: () => _stopMoving(),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),
                    SizedBox(width: buttonPadding),
                    ArrowButton(
                      icon: Icons.arrow_forward,
                      onTapDown: (_) => _startMoving('right'),
                      onTapUp: (_) => _stopMoving(),
                      onTapCancel: () => _stopMoving(),
                      iconSize: iconSize,
                      padding: buttonPadding,
                    ),
                  ],
                ),
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
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.05,
            child: IconButton(
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: iconSize * 1.5,
              ),
              onPressed: () {
                _checkForLetter(context, letterTiles);
              },
            ),
          ),
          if (_foundLetter != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.5 - 50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Center(
                  child: Text(
                    _foundLetter!,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: 'ComicSans',
                    ),
                  ),
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
          color: Colors.pinkAccent,
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
          onPressed: () {},
          iconSize: iconSize,
          padding: EdgeInsets.all(padding),
        ),
      ),
    );
  }
}

class GameGround extends StatelessWidget {
  final double characterXPosition;
  final double characterYPosition;
  final String characterDirection;
  final List<LetterTileData> letterTiles;

  GameGround({
    required this.characterXPosition,
    required this.characterYPosition,
    required this.characterDirection,
    required this.letterTiles,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Central Vertical Street
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 80,
            height: double.infinity,
            color: Colors.green[200]?.withOpacity(0.5),
          ),
        ),
        // Horizontal Street on the Left
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: screenWidth / 2 - 40,
            height: 80,
            color: Colors.green[300]?.withOpacity(0.5),
          ),
        ),
        // Horizontal Street on the Right
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screenWidth / 2 - 40,
            height: 80,
            color: Colors.green[300]?.withOpacity(0.5),
          ),
        ),
        // Letter Tiles
        ...letterTiles.map((tile) {
          return Positioned(
            left: tile.x,
            bottom: tile.y,
            child: LetterTile(letter: tile.letter),
          );
        }).toList(),
        // Character
        Positioned(
          bottom: characterYPosition,
          left: (screenWidth / 2) + characterXPosition - 25,
          child: Image.asset(
            characterDirection,
            width: 120,
            height: 120,
          ),
        ),
      ],
    );
  }
}

class LetterTile extends StatelessWidget {
  final String letter;

  LetterTile({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicSans',
          ),
        ),
      ),
    );
  }
}
