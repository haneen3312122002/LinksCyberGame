import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'video_background.dart';
import 'DataDescriptionBox.dart';
import 'choice_row.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String correctProtocol = '';
  final audioPlayer = AudioPlayer();

  void _showResultMessage(String message, bool correct) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (correct) {
                _loadNextData();
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    _playSound(correct ? "victory.mp3" : "Winning.mp3");
  }

  void _playSound(String fileName) {
    audioPlayer.play(AssetSource(fileName));
  }

  void _loadNextData() {
    if (mounted) {
      setState(() {});
    }
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
    return Scaffold(
      body: Stack(
        children: [
          VideoBackground(),
          SafeArea(
            child: Column(
              children: [
                DataDescriptionBox(onDataGenerated: _onDataGenerated),
                Spacer(),
                ChoiceRow(
                  onTcpSelected: () => _onChoiceMade('TCP'),
                  onUdpSelected: () => _onChoiceMade('UDP'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
