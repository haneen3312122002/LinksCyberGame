import 'package:flutter/material.dart';
import 'DoorsScreen5.dart'; // تأكد من وجود هذا الملف أو تغييره إذا لزم الأمر

class DesktopScreen4 extends StatefulWidget {
  const DesktopScreen4({Key? key}) : super(key: key);

  @override
  _AfterDoor4State createState() => _AfterDoor4State();
}

// كلاس لتخزين بيانات الصورة بدون حجم محدد
class ImageData {
  final String path;

  ImageData({
    required this.path,
  });
}

class _AfterDoor4State extends State<DesktopScreen4> {
  // نموذج بيانات للتطبيقات المفتوحة (الصور)
  List<ImageData> openApps = [
    ImageData(path: 'assets/google.png'),
    ImageData(path: 'assets/insta.png'),
    ImageData(path: 'assets/word.png'),
    ImageData(path: 'assets/photoshop.png'),
  ];

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

    // تحديد حجم الحشو والمسافات بين العناصر
    double gridPadding = 10.0;
    double gridSpacing = 8.0; // تقليل المسافات لجعل المربعات أصغر

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/AntiGameBack.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // محتوى الشاشة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // شبكة التطبيقات المفتوحة
                Expanded(
                  child: GridView.builder(
                    itemCount: openApps.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // عدد الأعمدة الديناميكي
                      crossAxisSpacing:
                          gridSpacing, // تقليل المسافة الأفقية بين الصور
                      mainAxisSpacing:
                          gridSpacing, // تقليل المسافة الرأسية بين الصور
                      childAspectRatio: 1.0, // مربّع
                    ),
                    itemBuilder: (context, index) {
                      final app = openApps[index];
                      return Stack(
                        children: [
                          // خلفية لكل عنصر في الشبكة
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                app.path,
                                fit: BoxFit.cover, // تغطية المساحة بالكامل
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          // زر الإغلاق في الزاوية العلوية اليمنى
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  // إغلاق التطبيق (إزالته من القائمة)
                                  openApps.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // شريط المهام في الأسفل
      bottomNavigationBar: Container(
        height: screenHeight * 0.08, // ارتفاع ديناميكي (8% من ارتفاع الشاشة)
        color: const Color.fromARGB(255, 9, 0, 40),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% من عرض الشاشة كحشو
          vertical: screenHeight * 0.01, // 1% من ارتفاع الشاشة كحشو عمودي
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // زر الانتقال إلى المرحلة التالية
            ElevatedButton(
              onPressed: () {
                // التحقق إذا كانت هناك تطبيقات مفتوحة
                if (openApps.isNotEmpty) {
                  // عرض التنبيه
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('تنبيه'),
                      content: const Text(
                        'عليك إغلاق جميع البرامج قبل الانتقال إلى المرحلة التالية!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('حسنًا'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // الانتقال إلى المرحلة التالية إذا أُغلقت جميع التطبيقات
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoorsScreen5()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 115, 157, 208),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01,
                ),
              ),
              child: Text(
                'المرحلة التالية',
                style: TextStyle(
                  color: const Color.fromARGB(255, 9, 0, 40),
                  fontSize: screenWidth * 0.015, // حجم خط متجاوب
                ),
              ),
            ),

            // أيقونات أخرى في شريط المهام
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 28),
                  onPressed: () {
                    // تنفيذ عند الضغط على زر الصفحة الرئيسية
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 28),
                  onPressed: () {
                    // تنفيذ عند الضغط على زر البحث
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
