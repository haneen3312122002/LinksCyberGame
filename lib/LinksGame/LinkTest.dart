import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cybergame/connection.dart'; // Import the API service

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
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
      _audioPlayer.setVolume(0.3);
      _audioPlayer.play();
    } catch (e) {
      print("Failed to play sound: $e");
    }
  }

  // Modified checkLink method to use ApiService
  void checkLink() async {
    String link = _linkController.text;

    try {
      print('Checking link: $link'); // Log the link being checked
      String linkResult = await ApiService.checkLink(link);
      print('Result: $linkResult'); // Log the result from the API

      setState(() {
        result = linkResult;
      });

      if (linkResult == 'secure') {
        await _playSound('assets/secure.mp3');
      } else if (linkResult == 'not secure') {
        await _playSound('assets/not_secure.mp3');
      } else if (linkResult == 'suspicious domain' ||
          linkResult == 'suspicious keyword' ||
          linkResult == 'link too long' ||
          linkResult == 'suspicious characters') {
        await _playSound('assets/warning.mp3');
      }
    } catch (e) {
      print('Error: $e'); // Log any errors
      setState(() {
        result = 'خطأ في الاتصال بالخادم'; // Error connecting to the server
      });
    }
  }

  Color boxColor(String result) {
    switch (result) {
      case 'secure':
        return Colors.green;
      case 'not secure':
        return Colors.red;
      case 'suspicious domain':
        return Colors.orange;
      case 'suspicious keyword':
        return Colors.yellow;
      case 'link too long':
        return Colors.purple;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/linksBack.gif",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                  child: Text(
                    'فحص الروابط',
                    style: TextStyle(
                      fontSize: screenHeight * 0.03,
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
                SizedBox(height: screenHeight * 0.015),
                SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.05,
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
                            fontSize: screenHeight * 0.02,
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
                SizedBox(height: screenHeight * 0.015),
                if (result.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: boxColor(result),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.02,
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
