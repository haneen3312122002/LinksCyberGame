import 'package:flutter/material.dart';
import 'DoorsScreen7.dart';

class DesktopScreen6 extends StatefulWidget {
  @override
  _DesktopScreen6State createState() => _DesktopScreen6State();
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

class _DesktopScreen6State extends State<DesktopScreen6> {
  bool _isWifiOn = false;
  late final List<ImageData> _images;

  @override
  void initState() {
    super.initState();
    // حجم الصور (مربعات صغيرة جدًا)
    const double iconSize = 30;

    _images = [
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file_infected.png',
          width: iconSize,
          height: iconSize),
    ];
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تنبيه'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسنًا'),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('فتح الملف'),
                onTap: () {
                  Navigator.pop(context);
                  _showAlert(context, 'جهازك معرض للخطر');
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('إرسال الملف'),
                onTap: () {
                  Navigator.pop(context);
                  _showAlert(context, 'جهازك معرض للخطر');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('حذف الملف'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _images.removeAt(index);
                  });
                  if (!_images.any((image) =>
                      image.path.contains('child_file_infected.png'))) {
                    _showAlert(context, 'تم حذف جميع الملفات المشبوهة!');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة لتحديد توزيع العناصر
    final screenWidth = MediaQuery.of(context).size.width;

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
          // شبكة الصور المبعثرة
          Positioned.fill(
            top: 5,
            left: 0,
            bottom: 60, // ترك مساحة لشريط المهام في الأسفل
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.3, // نصف عرض الشاشة للشبكة
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // عدد الأعمدة
                      crossAxisSpacing: 9.0, // تقليل المسافة الأفقية بين الصور
                      mainAxisSpacing: 9.0, // تقليل المسافة الرأسية بين الصور
                      childAspectRatio: 1.0, // مربّع
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return InkWell(
                        onTap: () {
                          if (image.path.contains('child_file_infected.png')) {
                            _showOptions(context, index);
                          } else if (image.path.contains('child_file.png')) {
                            _showAlert(context, 'الملف سليم');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent, // إزالة لون الخلفية
                            borderRadius:
                                BorderRadius.circular(3), // زوايا بسيطة
                          ),
                          child: Image.asset(
                            image.path,
                            fit: BoxFit.cover, // الصورة تملأ المربع بالكامل
                            width: 10,
                            height: 10,
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
                  // زر للتنقل إلى DoorsScreen4
                  ElevatedButton(
                    onPressed: () {
                      if (_images.any((image) =>
                          image.path.contains('child_file_infected.png'))) {
                        _showAlert(
                            context, 'عليك التخلص من جميع الملفات المشبوهة!');
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoorsScreen7()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 115, 157, 208),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                      width: 30,
                      height: 30,
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
