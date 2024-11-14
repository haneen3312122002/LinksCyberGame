import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'HackerScreen.dart';
import 'VictimScreen.dart';
import 'GameLevelData.dart';
import 'dart:math';

class TrojanHorseGame extends StatefulWidget {
  @override
  _TrojanHorseGameState createState() => _TrojanHorseGameState();
}

class _TrojanHorseGameState extends State<TrojanHorseGame> {
  final ValueNotifier<String> virusTypeNotifier = ValueNotifier('');
  final ValueNotifier<bool> fakeGoogleIconNotifier = ValueNotifier(false);
  final ValueNotifier<Color> backgroundColorNotifier =
      ValueNotifier(Colors.red);

  late AudioPlayer backgroundAudioPlayer;
  bool isAuthenticated = false;
  final GameLevels gameLevels = GameLevels();

  @override
  void initState() {
    super.initState();
    backgroundAudioPlayer = AudioPlayer();
    _initializeAndPlayBackgroundMusic();
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

  void _checkAnswer() {
    if (gameLevels.checkAnswer()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('إجابة صحيحة! انتقل للمرحلة التالية.')),
      );
      setState(() {
        if (gameLevels.isGameCompleted()) {
          isAuthenticated = true;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('إجابة خاطئة، حاول مرة أخرى!')),
      );
    }
  }

  Widget _buildGameInterface(BoxConstraints constraints) {
    final double imageSize = constraints.maxWidth * 0.08; // تقليل حجم الصورة
    final double fontSize = constraints.maxWidth * 0.015; // تقليل حجم الخط
    final double boxSize = constraints.maxWidth * 0.05;
    final double buttonWidth = constraints.maxWidth * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFF2A2D43), // لون خلفية فضائي
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // صندوق يحتوي على مؤشر المرحلة والسؤال بتصميم متصل
              Container(
                padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0), // حواف دائرية
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 56, 172, 255), // لون خاص بمؤشر المرحلة
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '🚀 المرحلة ${gameLevels.currentStep + 1}',
                        style: TextStyle(
                          fontSize: fontSize * 1.2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth * 0.02),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 255, 255, 255), // لون خاص بالسؤال
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          gameLevels.getCurrentLevel().question,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: fontSize * 1.2,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 63, 10, 154),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              // استدعاء الدالة الجديدة لتوزيع الصور والأحرف بشكل هرمي على الجانبين
              _buildLetteredImageGrid(imageSize, fontSize, buttonWidth),
              SizedBox(height: constraints.maxHeight * 0.015),
              _buildAnswerDisplay(boxSize, fontSize),
              SizedBox(height: constraints.maxHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: _checkAnswer,
                    child: Text(
                      'تحقق من الإجابة',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        gameLevels.removeLastLetter();
                      });
                    },
                    child: Text(
                      'مسح',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onVirusSend(String virusType) {
    virusTypeNotifier.value = virusType;
  }

  Widget _buildLetteredImageGrid(
      double imageSize, double fontSize, double buttonWidth) {
    // قائمة الصور
    List<String> images = gameLevels.getCurrentLevel().images;

    // قائمة الأحرف
    List<String> letters =
        List<String>.from(gameLevels.getCurrentLevel().answer.split(''))
          ..addAll(['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ']);
    letters.shuffle(); // خلط الأحرف

    // تقسيم الأحرف إلى نصفين
    List<String> leftLetters = letters.sublist(0, letters.length ~/ 2);
    List<String> rightLetters = letters.sublist(letters.length ~/ 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // هرم الأحرف على الجانب الأيسر
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leftLetters.length > 0)
              _buildCenteredRow([leftLetters[0]], fontSize, buttonWidth),
            if (leftLetters.length > 1)
              _buildCenteredRow(
                  leftLetters.sublist(1, min(3, leftLetters.length)),
                  fontSize,
                  buttonWidth),
            if (leftLetters.length > 3)
              _buildCenteredRow(
                  leftLetters.sublist(3, min(6, leftLetters.length)),
                  fontSize,
                  buttonWidth),
          ],
        ),
        SizedBox(width: 10), // مسافة بين الأحرف والصور

        // شبكة الصور
        SizedBox(
          width: imageSize * 2.5,
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: imageSize * 0.15,
            crossAxisSpacing: imageSize * 0.15,
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
        SizedBox(width: 10), // مسافة بين الصور والأحرف على اليمين

        // هرم الأحرف على الجانب الأيمن
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (rightLetters.length > 0)
              _buildCenteredRow([rightLetters[0]], fontSize, buttonWidth),
            if (rightLetters.length > 1)
              _buildCenteredRow(
                  rightLetters.sublist(1, min(3, rightLetters.length)),
                  fontSize,
                  buttonWidth),
            if (rightLetters.length > 3)
              _buildCenteredRow(
                  rightLetters.sublist(3, min(6, rightLetters.length)),
                  fontSize,
                  buttonWidth),
          ],
        ),
      ],
    );
  }

// دالة مساعدة لإنشاء صف مركزي يحتوي على أزرار الحروف
  Widget _buildCenteredRow(
      List<String> letters, double fontSize, double buttonWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: SizedBox(
            width: buttonWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  gameLevels.addLetter(letter);
                });
              },
              child: Text(
                letter,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!isAuthenticated) {
          return _buildGameInterface(constraints);
        }
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 1,
                child: HackerScreen(
                  onVirusSend: _onVirusSend,
                  backgroundColorNotifier: backgroundColorNotifier,
                  showFakeGoogleIconNotifier: fakeGoogleIconNotifier,
                ),
              ),
              SizedBox(width: constraints.maxWidth * 0.005),
              Expanded(
                flex: 1,
                child: VictimScreen(
                  virusTypeNotifier: virusTypeNotifier,
                  showFakeGoogleIconNotifier: fakeGoogleIconNotifier,
                  backgroundColorNotifier: backgroundColorNotifier,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageGrid(double imageSize) {
    List<String> images = gameLevels.getCurrentLevel().images;
    return Center(
      child: Container(
        width: imageSize * 2.5,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: imageSize * 0.15,
          crossAxisSpacing: imageSize * 0.15,
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
    List<String> letters =
        List<String>.from(gameLevels.getCurrentLevel().answer.split(''))
          ..addAll(['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ']);
    letters.shuffle();
    return Wrap(
      spacing: 3.0,
      runSpacing: 3.0,
      alignment: WrapAlignment.center,
      children: letters.map((letter) {
        return SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              setState(() {
                gameLevels.addLetter(letter);
              });
            },
            child: Text(
              letter,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnswerDisplay(double boxSize, double fontSize) {
    final String currentAnswer = gameLevels.answer;
    final int answerLength = gameLevels.getCurrentLevel().answer.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(answerLength, (index) {
        return Container(
          width: boxSize,
          height: boxSize,
          margin: EdgeInsets.all(boxSize * 0.05),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: index < currentAnswer.length
                ? Colors.deepPurple[100]
                : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              index < currentAnswer.length ? currentAnswer[index] : '',
              style: TextStyle(fontSize: fontSize, color: Colors.black),
            ),
          ),
        );
      }),
    );
  }
}
