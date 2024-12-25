import 'package:flutter/material.dart';
import 'DoorsScreen3.dart';

class DesktopScreen extends StatefulWidget {
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

class _DesktopScreen3State extends State<DesktopScreen> {
  // نجعل الحالة الافتراضية للواي فاي شغّالة
  bool _isWifiOn = true;

  // تم وضع عرض وارتفاع 24 كقيمة افتراضية
  final List<ImageData> _images = [
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
    ImageData(path: 'assets/child_file.png', width: 24, height: 24),
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
          // شبكة الصور في النصف الأيسر من الشاشة
          Positioned.fill(
            top: 5,
            left: 0,
            bottom: 60, // ترك مساحة لشريط المهام في الأسفل
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5, // نصف عرض الشاشة للشبكة
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // جرّب زيادة/تقليل الأعمدة
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0, // مربّع
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return Container(
                        // تقييد العنصر ليكون 24x24
                        constraints: BoxConstraints.tightFor(
                          width: image.width,
                          height: image.height,
                        ),
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
                  // زر للانتقال إلى DoorsScreen3
                  ElevatedButton(
                    onPressed: () {
                      if (_isWifiOn) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('عليك فصل الإنترنت أولاً!'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoorsScreen3(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 115, 157, 208),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'المرحلة التالية',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 9, 0, 40),
                      ),
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
