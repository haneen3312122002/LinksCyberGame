import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // مكتبة تشغيل الصوت

class VictimScreen extends StatefulWidget {
  final String virusType;

  VictimScreen({required this.virusType});

  @override
  _VictimScreenState createState() => _VictimScreenState();
}

class _VictimScreenState extends State<VictimScreen> {
  bool showMessage = false; // لإظهار الرسالة عند تشغيل الفيروس
  AudioPlayer audioPlayer = AudioPlayer(); // متغير لتشغيل الصوت

  @override
  void initState() {
    super.initState();
    if (widget.virusType == 'رسائل منبثقة') {
      _playEvilSoundAndShowMessage(); // تشغيل الصوت وعرض الرسالة إذا كان نوع الفيروس "رسائل منبثقة"
    }
  }

  // دالة لتشغيل الصوت وعرض الرسالة
  void _playEvilSoundAndShowMessage() async {
    await audioPlayer.play(
        AssetSource('Evil.mp3')); // تشغيل الصوت من assets باستخدام AssetSource
    setState(() {
      showMessage = true; // عرض الرسالة بعد تشغيل الصوت
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.9,
          margin: EdgeInsets.all(screenSize.width * 0.02),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 10),
            image: DecorationImage(
              image: AssetImage('assets/desktop1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenSize.height * 0.02),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDesktopIcon('My Homework', Icons.insert_drive_file),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDesktopIcon('Images', Icons.image),
                  SizedBox(height: screenSize.height * 0.02),
                  _buildDesktopIcon('Documents', Icons.folder),
                ],
              ),
              Positioned(
                bottom: screenSize.height * 0.05,
                right: screenSize.width * 0.05,
                child: _buildDesktopIcon('Recycle Bin', Icons.delete),
              ),
              if (showMessage)
                Center(
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'تم اختراق جهازك!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopIcon(String label, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            size: 70,
            color: const Color.fromARGB(255, 136, 120, 120),
          ),
          onPressed: () {},
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
