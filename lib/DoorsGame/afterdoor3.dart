import 'package:flutter/material.dart';
import 'DoorsScreen4.dart';

class DesktopScreen3 extends StatefulWidget {
  @override
  _DesktopScreen3State createState() => _DesktopScreen3State();
}

// كلاس لتخزين بيانات الصورة
class ImageData {
  final String path;
  final double width;
  final double height;

  ImageData({
    required this.path,
    required this.width,
    required this.height,
  });
}

class _DesktopScreen3State extends State<DesktopScreen3> {
  bool _isWifiOn = false;

  // قائمة بيانات الصور لعرضها في الشبكة مع تحديد العرض والارتفاع لكل صورة
  final List<ImageData> _images = [
    ImageData(path: 'assets/child_file_infected.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file_infected.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file_infected.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file_infected.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file.png', width: 15, height: 15),
    ImageData(path: 'assets/child_file.png', width: 15, height: 15),
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
          // شبكة الصور المبعثرة محاذاة إلى اليسار وتخصيص نصف عرض الشاشة
          Positioned.fill(
            top: 5,
            left: 0,
            bottom: 60, // ترك مساحة لشريط المهام في الأسفل
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5, // تخصيص نصف عرض الشاشة للشبكة
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // ثلاث أعمدة فقط
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1.0, // نسبة العرض إلى الارتفاع مربعة
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return SizedBox(
                        width: image.width,
                        height: image.height,
                        child: Image.asset(
                          image.path,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
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
                  // زر للتنقل إلى DoorsScreen4
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoorsScreen4()),
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
