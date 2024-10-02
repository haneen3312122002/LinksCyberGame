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
  int stageCount = 0; // عداد المراحل
  final GlobalKey<DataDescriptionBoxState> dataDescriptionBoxKey = GlobalKey<
      DataDescriptionBoxState>(); // مفتاح للتحكم في DataDescriptionBox
  late AudioPlayer backgroundPlayer; // مشغل الخلفية

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic(); // تشغيل الموسيقى عند بدء اللعبة
  }

  @override
  void dispose() {
    backgroundPlayer.dispose(); // إيقاف الموسيقى عند الخروج من الشاشة
    super.dispose();
  }

  // تشغيل الموسيقى الخلفية
  void _playBackgroundMusic() async {
    backgroundPlayer = AudioPlayer();
    await backgroundPlayer.play(AssetSource('carsong.mp3'),
        volume: 0.5); // تحديد ملف الصوت وتكراره
    backgroundPlayer
        .setReleaseMode(ReleaseMode.loop); // تشغيل الموسيقى بشكل متكرر
  }

  void _showResultMessage(String message, bool correct) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: correct
            ? Colors.green[100]
            : Colors.red[100], // تغيير خلفية الرسالة بناءً على الإجابة
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: correct
                ? Colors.green
                : Colors.red, // تغيير لون النص بناءً على الإجابة
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (correct) {
                setState(() {
                  stageCount++; // زيادة العداد عند الإجابة الصحيحة
                });
                _loadNextData(); // تحميل بيانات جديدة
              }
            },
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                color: correct ? Colors.green : Colors.red, // لون زر "OK"
              ),
            ),
          ),
        ],
      ),
    );
    _playSound(correct ? "correct.mp3" : "Winning.mp3");
  }

  void _playSound(String fileName) {
    audioPlayer.play(AssetSource(fileName));
  }

  void _loadNextData() {
    // استدعاء دالة توليد بيانات جديدة في DataDescriptionBox
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
      correctProtocol = protocol; // تخزين البروتوكول الصحيح
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
                DataDescriptionBox(
                  key: dataDescriptionBoxKey,
                  onDataGenerated: _onDataGenerated,
                ), // عرض بيانات جديدة
                Spacer(),
                ChoiceRow(
                  onTcpSelected: () => _onChoiceMade('TCP'),
                  onUdpSelected: () => _onChoiceMade('UDP'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: StageCounter(stageCount: stageCount), // عداد المراحل
          ),
        ],
      ),
    );
  }
}

// عداد المراحل داخل دائرة
class StageCounter extends StatelessWidget {
  final int stageCount;

  StageCounter({required this.stageCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // لون الخلفية
            border: Border.all(
              color: Colors.red, // لون الحدود
              width: 4,
            ),
          ),
          child: Center(
            child: Text(
              '$stageCount',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red, // لون النص
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Icon(Icons.flag, color: Colors.red, size: 50), // أيقونة العداد
      ],
    );
  }
}
