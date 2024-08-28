import 'package:flutter/material.dart';
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:video_player/video_player.dart';

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

class LinkChecker {
  static Future<String> checkLink(String link) async {
    return 'الرابط آمن'; // يمكن تغيير هذه القيمة لاختبار الحالة الأخرى
  }
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _linkController = TextEditingController();
  String result = '';
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset("videos/background.mp4")
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void checkLink() async {
    String link = _linkController.text;
    String linkResult = await LinkChecker.checkLink(link);

    setState(() {
      result = linkResult;
    });
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
          // إضافة الفيديو كخلفية
          if (_videoController.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
          // باقي عناصر اللعبة
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.06),
                  child: Text(
                    'فحص الروابط',
                    style: TextStyle(
                      fontSize: screenHeight * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
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
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.07,
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
                            fontSize: screenHeight * 0.025,
                          ),
                        ),
                        SizedBox(width: 7),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                if (result.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
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
