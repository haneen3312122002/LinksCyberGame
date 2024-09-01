import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

class LinkChecker {
  static Future<String> checkLink(String link) async {
    // يمكنك تغيير النتيجة هنا لاختبار الحالة الأخرى
    return 'الرابط آمن';
  }
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _linkController = TextEditingController();
  String result = '';
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String filePath) async {
    try {
      await _audioPlayer.setAsset(filePath);
      _audioPlayer.setVolume(0.3); // ضبط مستوى الصوت
      _audioPlayer.play();
    } catch (e) {
      print("Failed to play sound: $e");
    }
  }

  void checkLink() async {
    String link = _linkController.text;
    String linkResult = await LinkChecker.checkLink(link);

    setState(() {
      result = linkResult;
    });

    if (linkResult == 'الرابط آمن') {
      await _playSound('assets/secure.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color boxColor;
    if (result == 'الرابط آمن') {
      boxColor = Colors.green;
    } else if (result == 'الرابط غير آمن') {
      boxColor = Colors.red;
    } else {
      boxColor = Colors.transparent;
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Stack(
        children: [
          // إضافة GIF كخلفية
          SizedBox.expand(
            child: Image.asset(
              "assets/linksBack.gif",
              fit: BoxFit.cover,
            ),
          ),
          // باقي عناصر اللعبة
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01, // تقليل الهامش الرأسي
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      bottom: screenHeight * 0.015), // تقليل الهامش السفلي
                  child: Text(
                    'فحص الروابط',
                    style: TextStyle(
                      fontSize: screenHeight * 0.03, // تقليل حجم النص
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      hintText: 'أدخل الرابط هنا',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.015), // تقليل المسافة بين العناصر
                SizedBox(
                  width: screenWidth * 0.4, // تقليل عرض الزر
                  height: screenHeight * 0.05, // تقليل ارتفاع الزر
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: checkLink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'افحص الرابط',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenHeight * 0.02, // تقليل حجم النص داخل الزر
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.015), // تقليل المسافة بين العناصر
                if (result.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0), // تقليل الحشوة الداخلية
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius:
                          BorderRadius.circular(8.0), // تقليل الحواف الدائرية
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02, // تقليل حجم النص
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
