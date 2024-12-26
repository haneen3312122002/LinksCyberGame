import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DesktopScreen7 extends StatefulWidget {
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

class _DesktopScreen6State extends State<DesktopScreen7> {
  bool _isWifiOn = false;
  late final List<ImageData> _images;
  bool _victoryShown = false;

  @override
  void initState() {
    super.initState();
    // حجم الصور (مربعات صغيرة جدًا)
    const double iconSize = 30;

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
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
      ImageData(
          path: 'assets/child_file.png', width: iconSize, height: iconSize),
    ];
  }

  void _showStyledAlert(BuildContext context, String title, String message,
      {IconData? icon, Color? iconColor}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(icon ?? Icons.info, color: iconColor ?? Colors.blue, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showVictoryScreen(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('victory.mp3')); // تشغيل موسيقى النصر

    setState(() {
      _victoryShown = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Center(
          child: Text(
            '🎉 أحسنت عملاً 🎉',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 47, 103, 186)),
          ),
        ),
        content: const Text(
          'لقد قمت بالتغلب على الهجوم!',
          style:
              TextStyle(fontSize: 18, color: Color.fromARGB(255, 8, 49, 110)),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              player.stop(); // إيقاف الموسيقى عند إغلاق الرسالة
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showRestartDialog(BuildContext context) {
    _showStyledAlert(
      context,
      'إعادة تشغيل الجهاز',
      'سوف يتم إعادة تشغيل جهازك، هل تريد المتابعة؟',
      icon: Icons.restart_alt,
      iconColor: Colors.orange,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showVictoryScreen(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // شبكة الصور
          Positioned.fill(
            top: 5,
            left: 0,
            bottom: 60,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.3,
                  child: GridView.builder(
                    itemCount: _images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 9.0,
                      mainAxisSpacing: 9.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return InkWell(
                        onTap: () {
                          if (image.path.contains('child_file_infected.png')) {
                            _showStyledAlert(
                                context, 'تحذير', 'هذا الملف مصاب بالفيروس!',
                                icon: Icons.warning, iconColor: Colors.red);
                          } else if (image.path.contains('child_file.png')) {
                            _showStyledAlert(
                                context, 'معلومات', 'هذا الملف سليم!',
                                icon: Icons.check, iconColor: Colors.green);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Image.asset(
                            image.path,
                            fit: BoxFit.cover,
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
                  // زر إعادة التشغيل
                  IconButton(
                    icon: const Icon(Icons.restart_alt, color: Colors.white),
                    onPressed: () {
                      _showRestartDialog(context);
                    },
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
