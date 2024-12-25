import 'package:flutter/material.dart';
import 'DoorsScreen6.dart';

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

class DesktopScreen5 extends StatefulWidget {
  const DesktopScreen5({Key? key}) : super(key: key);

  @override
  _DesktopScreen5State createState() => _DesktopScreen5State();
}

class _DesktopScreen5State extends State<DesktopScreen5> {
  // نجعل الحالة الافتراضية للواي فاي شغّالة
  bool _isWifiOn = true;

  // متغير لتتبع ما إذا تم "تشغيل" مكافحة الفيروسات (بالضغط على الأيقونة)
  bool _isAntivirusOn = false;

  // قائمة الصور مع إضافة صورة مكافحة الفيروسات
  late final List<ImageData> _images;

  @override
  void initState() {
    super.initState();
    // سنعتمد على حجم شاشة الجهاز لجعل الصور قابلة للتمدد أو التصغير
    const double iconSize = 60; // تكبير حجم الصور قليلاً

    _images = [
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),

      // الأيقونة الجديدة (مكافحة الفيروسات)
      ImageData(
          path: 'assets/antivirus_icon.png', width: iconSize, height: iconSize),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // نحصل على أبعاد الشاشة
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية الشاشة
          Container(
            decoration: const BoxDecoration(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // عدد الأعمدة
                      crossAxisSpacing: 4.0, // تقليل المسافة الأفقية بين الصور
                      mainAxisSpacing: 4.0, // تقليل المسافة الرأسية بين الصور
                      childAspectRatio: 1.0, // مربّع
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];

                      return GestureDetector(
                        onTap: () {
                          // إذا كانت الصورة خاصة بمكافحة الفيروسات، نعتبره "تشغيل"
                          if (image.path.contains('antivirus_icon.png')) {
                            setState(() {
                              _isAntivirusOn = true;
                            });

                            // عرض التنبيه في وسط الشاشة
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('تنبيه'),
                                  content:
                                      const Text('تم تشغيل مكافحة الفيروسات'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('حسنًا'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Center(
                          child: Image.asset(
                            image.path,
                            fit: BoxFit.contain,
                            width: image.width,
                            height: image.height,
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
              height: 60,
              color: const Color.fromARGB(255, 4, 23, 73),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر "المرحلة التالية"
                  ElevatedButton(
                    onPressed: () {
                      if (!_isAntivirusOn) {
                        // برنامج مكافحة الفيروسات لم يتم تشغيله
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('تنبيه'),
                              content: const Text(
                                  'عليك تشغيل برنامج مكافحة الفيروسات أولاً!'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('حسنًا'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // الانتقال إلى المرحلة التالية
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoorsScreen6(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 115, 157, 208),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'المرحلة التالية',
                      style: TextStyle(
                        color: Color.fromARGB(255, 9, 0, 40),
                      ),
                    ),
                  ),

                  // أيقونة الواي فاي
                  IconButton(
                    icon: Image.asset(
                      _isWifiOn ? 'assets/wifigreen.png' : 'assets/wifired.png',
                      width: 40, // حجم الأيقونة
                      height: 40,
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
