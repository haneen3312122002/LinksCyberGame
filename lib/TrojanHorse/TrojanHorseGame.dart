import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // استيراد مكتبة الصوت
import 'HackerScreen.dart'; // استدعاء كلاس شاشة الهاكر
import 'VictimScreen.dart'; // استدعاء كلاس شاشة الضحية

class TrojanHorseGame extends StatefulWidget {
  @override
  TwoUsersScreenState createState() => TwoUsersScreenState();
}

class TwoUsersScreenState extends State<TrojanHorseGame> {
  String virusType = ''; // تخزين نوع الفيروس
  bool showFakeGoogleIcon = false; // لتحديد إذا كان يجب عرض أيقونة غوغل المزيفة
  AudioPlayer audioPlayer = AudioPlayer(); // متغير لتشغيل الصوت

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic(); // تشغيل الصوت عند بدء اللعبة
  }

  @override
  void dispose() {
    audioPlayer.stop(); // إيقاف الصوت عند إغلاق الشاشة
    super.dispose();
  }

  // تشغيل الصوت في الخلفية
  void _playBackgroundMusic() async {
    await audioPlayer
        .setReleaseMode(ReleaseMode.loop); // تكرار الصوت بشكل مستمر
    await audioPlayer
        .play(AssetSource('Evil laugh.mp3')); // تشغيل الصوت من assets
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // شاشة الهاكر
          Expanded(
            child: HackerScreen(
              onVirusSend: () {
                setState(() {
                  virusType =
                      'رسائل منبثقة'; // تمرير نوع الفيروس بدلاً من حالة حذف الملف
                  showFakeGoogleIcon =
                      true; // عند إرسال الفيروس، يتم إظهار الأيقونة المزيفة
                });
              },
            ),
          ),
          // مسافة بين الشاشتين
          SizedBox(width: 20), // يمكنك تعديل العرض حسب الحاجة

          // شاشة الضحية
          Expanded(
            child: VictimScreen(
              virusType: virusType,
              showFakeGoogleIcon:
                  showFakeGoogleIcon, // تمرير الحالة إلى شاشة الضحية
            ),
          ),
        ],
      ),
    );
  }
}
