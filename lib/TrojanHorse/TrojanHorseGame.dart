import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'HackerScreen.dart';
import 'VictimScreen.dart';
import 'GameLevelData.dart';

class TrojanHorseGame extends StatefulWidget {
  @override
  _TrojanHorseGameState createState() => _TrojanHorseGameState();
}

class _TrojanHorseGameState extends State<TrojanHorseGame> {
  final ValueNotifier<String> virusTypeNotifier =
      ValueNotifier(''); // للتحكم في نوع الفيروس
  final ValueNotifier<bool> fakeGoogleIconNotifier =
      ValueNotifier(false); // للتحكم في إظهار الأيقونة المزيفة
  final ValueNotifier<Color> backgroundColorNotifier =
      ValueNotifier(Colors.red); // للتحكم في لون الخلفية

  late AudioPlayer backgroundAudioPlayer;
  bool isAuthenticated = false; // متغير لتحديد حالة المصادقة لإظهار الشاشتين

  final GameLevels gameLevels = GameLevels(); // إعدادات اللعبة لمراحل التحدي

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

  // التحقق من إجابة المرحلة الحالية لتحديد التقدم في اللعبة
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

  // إعداد شاشة اللعبة قبل الانتقال إلى الشاشتين
  Widget _buildGameInterface(double screenWidth, double screenHeight) {
    final double imageSize = screenWidth * 0.10;
    final double fontSize = screenWidth * 0.020;
    final double boxSize = screenWidth * 0.03;
    final double buttonWidth = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 144, 149, 180),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'المرحلة ${gameLevels.currentStep + 1}: ${gameLevels.getCurrentLevel().question}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize * 1.4, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.015),
              _buildImageGrid(imageSize),
              SizedBox(height: screenHeight * 0.015),
              _buildAnswerDisplay(boxSize, fontSize),
              SizedBox(height: screenHeight * 0.015),
              _buildLetterGrid(fontSize, buttonWidth),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _checkAnswer,
                    child: Text('تحقق من الإجابة',
                        style: TextStyle(fontSize: fontSize * 0.9)),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameLevels.removeLastLetter();
                      });
                    },
                    child:
                        Text('مسح', style: TextStyle(fontSize: fontSize * 0.9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتحديث نوع الفيروس وإرساله إلى شاشة الضحية
  void _onVirusSend(String virusType) {
    virusTypeNotifier.value = virusType;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // التحقق من حالة المصادقة لعرض الشاشة المناسبة
    if (!isAuthenticated) {
      return _buildGameInterface(screenSize.width, screenSize.height);
    }

    // إذا كانت المصادقة ناجحة، يتم عرض شاشتي الهاكر والضحية جنباً إلى جنب
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
          SizedBox(width: screenSize.width * 0.005),
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
  }

  // عناصر أخرى لشاشة اللعبة
  Widget _buildImageGrid(double imageSize) {
    List<String> images = gameLevels.getCurrentLevel().images;
    return Center(
      child: Container(
        width: imageSize * 2.5,
        child: GridView.count(
          crossAxisCount: 2,
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
            onPressed: () {
              setState(() {
                gameLevels.addLetter(letter);
              });
            },
            child: Text(letter, style: TextStyle(fontSize: fontSize)),
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
            color:
                index < currentAnswer.length ? Colors.blue[100] : Colors.white,
          ),
          child: Center(
            child: Text(
              index < currentAnswer.length ? currentAnswer[index] : '',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      }),
    );
  }
}
