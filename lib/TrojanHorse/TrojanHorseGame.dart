import 'package:flutter/material.dart';
import 'HackerScreen.dart'; // استدعاء كلاس شاشة الهاكر
import 'VictimScreen.dart'; // استدعاء كلاس شاشة الضحية

class TrojanHorseGame extends StatefulWidget {
  @override
  TwoUsersScreenState createState() => TwoUsersScreenState();
}

class TwoUsersScreenState extends State<TrojanHorseGame> {
  String virusType = ''; // يمكنك هنا تخزين نوع الفيروس بدلاً من حالة حذف الملف

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
                });
              },
            ),
          ),
          // مسافة بين الشاشتين
          SizedBox(width: 20), // يمكنك تعديل العرض حسب الحاجة

          // شاشة الضحية
          Expanded(
            child: VictimScreen(virusType: virusType), // تمرير نوع الفيروس
          ),
        ],
      ),
    );
  }
}
