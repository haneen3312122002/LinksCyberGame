import 'package:flutter/material.dart';
import 'package:cybergame/SessionLayerGame/TunnelBackground.dart'; // استدعاء كلاس الخلفية
import 'package:cybergame/SessionLayerGame/SideColumn.dart'; // استدعاء كلاس العمود الجانبي
import 'package:cybergame/SessionLayerGame/SecondColumn .dart'; // استدعاء كلاس العمود الثاني

class SessionLayerScreen extends StatefulWidget {
  @override
  _SessionLayerScreenState createState() => _SessionLayerScreenState();
}

class _SessionLayerScreenState extends State<SessionLayerScreen> {
  List<String> secondColumnBlocks = [];

  // دالة لإضافة البلوك إلى العمود الثاني
  void onBlockDragged(String block) {
    setState(() {
      secondColumnBlocks.add(block);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Layer Game'),
        centerTitle: true,
      ),
      body: Row(
        children: [
          SideColumn(onBlockDragged: onBlockDragged), // استدعاء العمود الجانبي
          Expanded(
            child: Stack(
              children: [
                TunnelBackground(), // استخدام الخلفية
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ترتيب خطوات الجلسة:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
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
          ),
          SecondColumn(blocks: secondColumnBlocks), // استدعاء العمود الثاني
        ],
      ),
    );
  }
}
