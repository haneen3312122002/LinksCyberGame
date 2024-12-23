import 'package:flutter/material.dart';
import 'DoorsScreen3.dart';

class DesktopScreen extends StatefulWidget {
  @override
  _DesktopScreenState createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  bool _isWifiOn = false;

  // قائمة مسارات الصور لعرضها في الشبكة
  final List<String> _imagePaths = [
    'assets/child_file.png',
    'assets/child_file.png',
    'assets/child_file.png',
    'assets/child_file.png',
    'assets/child_file.png',
    'assets/child_file.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الشاشة
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AntiGameBack.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // شبكة الصور المبعثرة

          Positioned.fill(
            top: 5,
            left: 0,
            bottom: 60, // ترك مساحة لشريط المهام في الأسفل
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: _imagePaths.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10, // زيادة عدد الأعمدة لجعل الصور أصغر
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 1.0, // نسبة العرض إلى الارتفاع مربعة
                ),
                itemBuilder: (context, index) {
                  return Image.asset(
                    _imagePaths[index],
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
          // شريط المهام في الأسفل
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: const Color.fromARGB(255, 4, 23, 73),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر للتنقل إلى DoorsScreen3
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoorsScreen3()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 115, 157, 208),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'المرحلة التالية',
                      style:
                          TextStyle(color: const Color.fromARGB(255, 9, 0, 40)),
                    ),
                  ),
                  // أيقونة الواي فاي
                  IconButton(
                    icon: Image.asset(
                      _isWifiOn ? 'assets/wifigreen.png' : 'assets/wifired.png',
                      width: 60,
                      height: 60,
                    ),
                    onPressed: () {
                      setState(() {
                        _isWifiOn = !_isWifiOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
