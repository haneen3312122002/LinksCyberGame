import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'video_background.dart';
import 'DataDescriptionBox.dart';

class CarGameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<CarGameScreen> {
  String correctProtocol = '';
  final audioPlayer = AudioPlayer();
  int stageCount = 0;
  final GlobalKey<DataDescriptionBoxState> dataDescriptionBoxKey =
      GlobalKey<DataDescriptionBoxState>();
  late AudioPlayer backgroundPlayer;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    backgroundPlayer.dispose();
    super.dispose();
  }

  void _playBackgroundMusic() async {
    backgroundPlayer = AudioPlayer();
    await backgroundPlayer.play(AssetSource('carsong.mp3'), volume: 0.5);
    backgroundPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _showResultMessage(String message, bool correct) {
    final color = correct ? Colors.green : Colors.red;
    final dialogType = correct ? DialogType.success : DialogType.error;

    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      title: correct ? 'أحسنت!' : 'خطأ!',
      desc: message,
      btnOkOnPress: () {
        if (correct) {
          setState(() {
            stageCount++;
          });
          _loadNextData();
        }
      },
      btnOkText: 'موافق',
      btnOkColor: color,
      btnOkIcon: Icons.check_circle,
      descTextStyle:
          TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
    ).show();

    _playSound(correct ? "correct.mp3" : "Winning.mp3");
  }

  void _playSound(String fileName) {
    audioPlayer.play(AssetSource(fileName));
  }

  void _loadNextData() {
    dataDescriptionBoxKey.currentState?.generateRandomData();
  }

  void _onChoiceMade(String choice) {
    bool correct = choice == correctProtocol;
    _showResultMessage(
        correct
            ? 'اختيارك صحيح!'
            : 'اختيارك خاطئ، البروتوكول الصحيح هو $correctProtocol',
        correct);
  }

  void _onDataGenerated(String protocol) {
    setState(() {
      correctProtocol = protocol;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          VideoBackground(),
          SafeArea(
            child: Column(
              children: [
                DataDescriptionBox(
                  key: dataDescriptionBoxKey,
                  onDataGenerated: _onDataGenerated,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceContainer(
                      label: 'TCP',
                      onTap: () => _onChoiceMade('TCP'),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    ChoiceContainer(
                      label: 'UDP',
                      onTap: () => _onChoiceMade('UDP'),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.02,
            right: screenWidth * 0.02,
            child: StageCounter(stageCount: stageCount),
          ),
        ],
      ),
    );
  }
}

// ChoiceContainer with rounded corners and smaller size for TCP/UDP
class ChoiceContainer extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  ChoiceContainer({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.18,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}

// Compact StageCounter for top-right
class StageCounter extends StatelessWidget {
  final int stageCount;

  StageCounter({required this.stageCount});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.08,
          height: screenWidth * 0.08,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.red,
              width: screenWidth * 0.005,
            ),
          ),
          child: Center(
            child: Text(
              '$stageCount',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Icon(Icons.flag, color: Colors.red, size: screenWidth * 0.06),
      ],
    );
  }
}
