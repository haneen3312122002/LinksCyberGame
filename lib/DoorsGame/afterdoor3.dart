import 'package:flutter/material.dart';
import 'DoorsScreen4.dart'; // تأكد من أن هذا المسار صحيح أو قم بتعديله إذا لزم الأمر

class DesktopScreen3 extends StatefulWidget {
  @override
  _DesktopScreen3State createState() => _DesktopScreen3State();
}

// كلاس لتخزين بيانات الصورة باستخدام حجم واحد
class ImageData {
  final String path;
  final double size; // حجم واحد للأبعاد

  ImageData({
    required this.path,
    required this.size,
  });
}

class _DesktopScreen3State extends State<DesktopScreen3> {
  bool _isWifiOn = false;

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // تحديد حجم الأيقونات بناءً على عرض الشاشة (5% من عرض الشاشة)
    double iconSize = screenWidth * 0.05;

    // تحديد عدد الأعمدة بناءً على عرض الشاشة
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    // قائمة الصور بالحجم الجديد
    final List<ImageData> _images = [
      ImageData(path: 'assets/child_file_infected.png', size: iconSize),
      ImageData(path: 'assets/child_file.png', size: iconSize),
      ImageData(path: 'assets/child_file.png', size: iconSize),
      ImageData(path: 'assets/child_file_infected.png', size: iconSize),
      ImageData(path: 'assets/child_file_infected.png', size: iconSize),
      ImageData(path: 'assets/child_file.png', size: iconSize),
      ImageData(path: 'assets/child_file_infected.png', size: iconSize),
      ImageData(path: 'assets/child_file.png', size: iconSize),
      ImageData(path: 'assets/child_file.png', size: iconSize),
    ];

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
            bottom: screenHeight * 0.1, // ترك مساحة لشريط المهام في الأسفل
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: screenWidth > 1200
                      ? 0.3
                      : 0.5, // تعديل عرض الشبكة بناءً على عرض الشاشة
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // عدد الأعمدة الديناميكي
                      crossAxisSpacing: 9.0, // زيادة المسافة الأفقية بين الصور
                      mainAxisSpacing: 9.0, // زيادة المسافة الرأسية بين الصور
                      childAspectRatio: 1.0, // مربّع
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return InkWell(
                        onTap: () {
                          // إذا كانت الصورة مصابة
                          if (image.path.contains('child_file_infected')) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.red),
                                    SizedBox(width: 10),
                                    Text(
                                      'تنبيه',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Text('لا تقم بفتح الملفات المشبوهة'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('إغلاق'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: image.size,
                          height: image.size,
                          child: Image.asset(
                            image.path,
                            fit: BoxFit.contain,
                          ),
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
              height:
                  screenHeight * 0.08, // ارتفاع ديناميكي (8% من ارتفاع الشاشة)
              color: const Color.fromARGB(255, 4, 23, 73),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // 5% من عرض الشاشة كحشو
              ),
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
                      style: TextStyle(
                        color: const Color.fromARGB(255, 9, 0, 40),
                      ),
                    ),
                  ),
                  // أيقونة الواي فاي
                  IconButton(
                    icon: Image.asset(
                      _isWifiOn ? 'assets/wifigreen.png' : 'assets/wifired.png',
                      width: screenWidth * 0.08, // 6% من عرض الشاشة
                      height: screenWidth * 0.08, // 6% من عرض الشاشة
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
