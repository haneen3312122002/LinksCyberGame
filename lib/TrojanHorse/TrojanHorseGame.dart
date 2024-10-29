import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'HackerScreen.dart';
import 'VictimScreen.dart';

class TrojanHorseGame extends StatefulWidget {
  @override
  _TrojanHorseGameState createState() => _TrojanHorseGameState();
}

class _TrojanHorseGameState extends State<TrojanHorseGame> {
  final ValueNotifier<String> virusTypeNotifier = ValueNotifier('');
  final ValueNotifier<bool> fakeGoogleIconNotifier = ValueNotifier(false);
  late AudioPlayer backgroundAudioPlayer;
  bool isAuthenticated = false;
  String answer = '';
  int step = 0;
  List<String> selectedLetters = [];

  final List<String> levelAnswers = ['حصان', 'انتشار', 'تصيد'];

  @override
  void initState() {
    super.initState();
    backgroundAudioPlayer = AudioPlayer();
    _initializeAndPlayBackgroundMusic();
    _resetLevel();
  }

  @override
  void dispose() {
    backgroundAudioPlayer.stop();
    backgroundAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeAndPlayBackgroundMusic() async {
    try {
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await backgroundAudioPlayer.play(AssetSource('Evil_laugh.mp3'));
    } catch (error) {
      print("Error playing background music: $error");
    }
  }

  void _resetLevel() {
    answer = '';
    selectedLetters = [];
    setState(() {});
  }

  void _checkAnswer() {
    if (answer == levelAnswers[step]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('إجابة صحيحة! انتقل للمرحلة التالية.')),
      );
      setState(() {
        step++;
        if (step >= levelAnswers.length) {
          isAuthenticated = true;
        } else {
          _resetLevel();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('إجابة خاطئة، حاول مرة أخرى!')),
      );
    }
  }

  String _getHint(int step) {
    switch (step) {
      case 0:
        return "ما الكلمة المشتركة بين الصور التي ترتبط بفيروسات التروجان؟";
      case 1:
        return "ما الكلمة المشتركة التي ترتبط بطريقة انتشار الفيروسات؟";
      case 2:
        return "ما الكلمة التي تصف هجومًا خداعيًا؟";
      default:
        return "";
    }
  }

  Widget _buildImageGrid(int step, double imageSize) {
    List<String> images = [];
    switch (step) {
      case 0:
        images = ["HourseL1.png", "Box.png", "Danger.png", "Lock.png"];
        break;
      case 1:
        images = [
          "network_cable.png",
          "wifi_spread.png",
          "computer_phone.png",
          "transfer_arrow.png"
        ];
        break;
      case 2:
        images = [
          "phishing_email.png",
          "malicious_link.png",
          "fake_login.png",
          "anonymous_message.png"
        ];
        break;
    }

    return Center(
      child: Container(
        width: imageSize * 2.5, // Control the total grid size
        child: GridView.count(
          crossAxisCount: 2, // Display images in a 2x2 grid
          shrinkWrap: true,
          mainAxisSpacing: imageSize * 0.2,
          crossAxisSpacing: imageSize * 0.2,
          children: images
              .map((image) => Container(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(
                      image,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLetterGrid(double fontSize, double buttonWidth) {
    List<String> letters = List<String>.from(levelAnswers[step].split(''))
      ..addAll(['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ']);
    letters.shuffle(); // Shuffle letters to add a challenge
    return Wrap(
      spacing: 3.0,
      runSpacing: 3.0,
      alignment: WrapAlignment.center,
      children: letters.map((letter) {
        return SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: () {
              if (answer.length < levelAnswers[step].length) {
                setState(() {
                  answer += letter;
                  selectedLetters.add(letter);
                });
              }
            },
            child: Text(letter, style: TextStyle(fontSize: fontSize)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnswerDisplay(double boxSize, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(levelAnswers[step].length, (index) {
        return Container(
          width: boxSize,
          height: boxSize,
          margin: EdgeInsets.all(boxSize * 0.05),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: index < answer.length ? Colors.blue[100] : Colors.white,
          ),
          child: Center(
            child: Text(
              index < answer.length ? answer[index] : '',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      }),
    );
  }

  void _onVirusSend(String virusType) {
    virusTypeNotifier.value = virusType;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double imageSize =
        screenSize.width * 0.10; // Smaller image size for the grid
    final double fontSize =
        screenSize.width * 0.020; // Further reduced font size
    final double boxSize =
        screenSize.width * 0.03; // Smaller box for answer display
    final double buttonWidth =
        screenSize.width * 0.05; // Smaller button size for letters

    if (!isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'المرحلة ${step + 1}: ${_getHint(step)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize * 1.4, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenSize.height * 0.015),
                _buildImageGrid(step, imageSize),
                SizedBox(height: screenSize.height * 0.015),
                _buildAnswerDisplay(boxSize, fontSize),
                SizedBox(height: screenSize.height * 0.015),
                _buildLetterGrid(fontSize, buttonWidth),
                SizedBox(height: screenSize.height * 0.015),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: Text('تحقق من الإجابة',
                      style: TextStyle(fontSize: fontSize * 0.9)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: HackerScreen(
              onVirusSend: (virusType) => _onVirusSend(virusType),
            ),
          ),
          SizedBox(width: screenSize.width * 0.005),
          Expanded(
            flex: 1,
            child: VictimScreen(
              virusTypeNotifier: virusTypeNotifier,
              showFakeGoogleIconNotifier: fakeGoogleIconNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
