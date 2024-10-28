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
  final TextEditingController answerController = TextEditingController();
  bool isAuthenticated = false;
  String partialPassword = '';
  int step = 0;

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

  void _checkAnswer(String answer) {
    bool isCorrect = false;

    switch (step) {
      case 0:
        if (answer.toLowerCase() == 'l') {
          isCorrect = true;
          partialPassword += answer;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('صحيح! انتقل للمرحلة الثانية.')),
          );
        }
        break;
      case 1:
        if (answer == '17') {
          isCorrect = true;
          partialPassword += answer;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ممتاز! الآن المرحلة الثالثة.')),
          );
        }
        break;
      case 2:
        if (answer.toLowerCase() == 'y') {
          isCorrect = true;
          partialPassword += answer;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('رائع! وصلت للمرحلة الأخيرة.')),
          );
        }
        break;
      case 3:
        if (answer == '22') {
          isCorrect = true;
          partialPassword += answer;
          if (partialPassword == 'l17y22') {
            setState(() {
              isAuthenticated = true;
            });
          }
        }
        break;
    }

    if (isCorrect) {
      // الانتقال للمرحلة التالية إذا كانت الإجابة صحيحة
      setState(() {
        step++;
      });
    } else {
      // إذا كانت الإجابة خاطئة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الإجابة غير صحيحة، حاول مرة أخرى!')),
      );
    }
  }

  // الدالة المضافة لتحديث نوع الفيروس
  void _onVirusSend(String virusType) {
    virusTypeNotifier.value = virusType;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final spacing = screenSize.width * 0.02;

    if (!isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'أدخل الإجابات للمرحلة ${step + 1}:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16),
                Text(
                  'المرحلة ${step + 1}: ${_getHint(step)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'أدخل الإجابة هنا',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _checkAnswer(answerController.text),
                  child: Text('تحقق من الإجابة'),
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
          SizedBox(width: spacing),
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

  String _getHint(int step) {
    switch (step) {
      case 0:
        return "ابحث عن تاريخ أول فيروس *Trojan* واستخرج الحرف الثالث من اسم مكتشفه.";
      case 1:
        return "احسب عدد حروف فيروسات S و W و T، واجمع عدد الحروف فيها.";
      case 2:
        return "استخرج الحرف الأخير من أول حرفين في اسم الفيروس المستخدم لمكافحة برامج التجسس.";
      case 3:
        return "ابحث عن عدد إصدارات فيروس *Trojan* واختر الرقم العشري.";
      default:
        return "";
    }
  }
}
