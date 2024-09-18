import 'package:flutter/material.dart';
import 'package:cybergame/SessionLayerGame/TunnelBackground.dart'; // استدعاء كلاس الخلفية

class SessionLayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Layer Game'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          TunnelBackground(), // استخدام الخلفية
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ترتيب خطوات الجلسة:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // هنا سيتم إضافة الأدوات الخاصة بترتيب الخطوات
                ElevatedButton(
                  onPressed: () {
                    // قم بإضافة الوظيفة هنا لاحقًا
                  },
                  child: Text('ابدأ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
