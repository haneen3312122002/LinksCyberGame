import 'package:flutter/material.dart';
import 'DoorsScreen5.dart'; // تأكد من وجود هذا الملف أو تغييره إذا لزم الأمر

class AfterDoor4 extends StatefulWidget {
  const AfterDoor4({Key? key}) : super(key: key);

  @override
  _AfterDoor4State createState() => _AfterDoor4State();
}

class _AfterDoor4State extends State<AfterDoor4> {
  // نموذج بيانات للتطبيقات المفتوحة (الصور)
  List<Map<String, dynamic>> openApps = [
    {'image': 'assets/google.png'},
    {'image': 'assets/insta.png'},
    {'image': 'assets/word.png'},
    {'image': 'assets/photoshop.png'},
  ];

  @override
  Widget build(BuildContext context) {
    // للحصول على حجم الشاشة الحالي (للمساعدة في ضبط الأحجام ديناميكيًا)
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // جسم الشاشة
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // عدد الأعمدة
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1, // النسبة بين العرض والارتفاع
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
                            child: Center(
                              // عرض الصورة فقط
                              child: Image.asset(
                                app['image'],
                                fit: BoxFit.contain,
                                // تصغير حجم الصورة لتكون صغيرة جدًا
                                width: screenSize.width * 0.08,
                                height: screenSize.width * 0.08,
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
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 9, 0, 40),
        child: SizedBox(
          height: 3,
          width: 3, // ارتفاع شريط المهام
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'المرحلة التالية ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 0, 40),
                  ),
                ),
              ),

              // أيقونات أخرى في شريط المهام
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
        ),
      ),
    );
  }
}
