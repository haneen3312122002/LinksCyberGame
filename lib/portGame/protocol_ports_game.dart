import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // استيراد مكتبة just_audio

class ProtocolPortsGame extends StatefulWidget {
  @override
  _ProtocolPortsGameState createState() => _ProtocolPortsGameState();
}

class _ProtocolPortsGameState extends State<ProtocolPortsGame> {
  final Map<String, int> protocolsPorts = {
    'HTTP': 80,
    'HTTPS': 443,
    'TCP': 6,
    'UDP': 17,
    'FTP': 21,
    'DNS': 53,
    'SMTP': 25,
    'IMAP': 143,
    'SSH': 22,
    'Telnet': 23,
  };

  Map<String, String> userAnswers = {};
  Map<String, Color> fieldColors = {};
  bool hasErrors = false;
  final AudioPlayer _audioPlayer = AudioPlayer(); // إنشاء كائن مشغل الصوت

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  // إعادة تعيين الحقول
  void _resetGame() {
    setState(() {
      protocolsPorts.forEach((protocol, port) {
        userAnswers[protocol] = ''; // تفريغ الإجابات
        fieldColors[protocol] = Colors.white; // إعادة تعيين اللون إلى الأبيض
      });
      hasErrors = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProtocolColumns(),
                  SizedBox(height: 25),
                  // تكبير حجم زر "Check All Answers" وتغيير لونه
                  ElevatedButton(
                    onPressed: _checkAllAnswers,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      backgroundColor:
                          const Color.fromARGB(255, 39, 43, 51), // لون الخلفية
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ), // تكبير النص
                    ),
                    child: Text('Check All Answers'),
                  ),
                  SizedBox(height: 20),
                  if (hasErrors)
                    Column(
                      children: [
                        Text(
                          'There are errors, please try again!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _resetGame,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            backgroundColor: const Color.fromARGB(
                                255, 255, 252, 59), // لون زر "Retry"
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              // تعديل نمط النص المدخل
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolColumns() {
    var halfLength = (protocolsPorts.length / 2).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildProtocolColumn(0, halfLength)),
        Expanded(
            child: _buildProtocolColumn(halfLength, protocolsPorts.length)),
      ],
    );
  }

  Widget _buildProtocolColumn(int start, int end) {
    List<String> protocols = protocolsPorts.keys.toList();
    return Column(
      children: protocols.sublist(start, end).map((protocol) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue, // لون الخلفية
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  protocol,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // تعديل النص في TextField وإعادة تلوين الخلفية
                TextField(
                  onChanged: (value) {
                    setState(() {
                      userAnswers[protocol] = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fieldColors[protocol], // لون خلفية الإدخال
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Port number',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(
                    // تعديل نمط النص المدخل
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _checkAllAnswers() async {
    bool allCorrect = true;
    setState(() {
      protocolsPorts.forEach((protocol, correctPort) {
        int userPort = int.tryParse(userAnswers[protocol]!) ?? 0;
        if (userPort == correctPort) {
          fieldColors[protocol] =
              const Color.fromARGB(255, 134, 241, 138); // لون النجاح
        } else {
          fieldColors[protocol] =
              const Color.fromARGB(255, 235, 83, 72); // لون الفشل
          allCorrect = false;
        }
      });
      hasErrors = !allCorrect;
    });

    if (allCorrect) {
      await _playSound('assets/victory.mp3');
    } else {
      await _playSound('assets/loss.mp3');
    }
  }

  Future<void> _playSound(String assetPath) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(assetPath); // تحميل الصوت من الأصول
      await player.play(); // تشغيل الصوت
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}
