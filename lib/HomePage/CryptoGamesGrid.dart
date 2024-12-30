import 'package:flutter/material.dart';
import 'GamePartsCard.dart';

class CryptoGamesGrid extends StatelessWidget {
  final List<String> imagesPaths = [
    'assets/netWorkPart.png',
    'assets/linkback.png',
    'assets/fiveback.png',
    'assets/viros.png',
    'assets/eightback.png',
    'assets/nineback.png',
    'assets/ports.png',
    'assets/19back.png',
    'assets/doorback.png',
  ];

  final List<String> partsTitles = [
    'حكاية الشبكة', //
    'مكتشف خدع الروابط', //
    'مغامرة الاحرف', //
    'الفايروسات العجيبة ',
    'مهمة انقاذ الحاسوب', //
    'حماية الفضاء الرقمي', //
    'بوابات الانترنت السرية', //
    ' عالم الاطفال الامن', //
    'فرقة الاستجابة السريعة ', //

    // Add the new title
  ];
//hh
  Map<String, String> personalInfo; // Example personal info
  CryptoGamesGrid({required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 3;

    return Column(
      children: [
        // العنوان في أعلى الصفحة وفي المنتصف أفقيًا
        Container(
          alignment: Alignment.center, // يجعل المحتوى في المنتصف أفقيًا
          padding: const EdgeInsets.only(top: 0.0, bottom: 20.0),
          child: Text(
            'Secure Adventures',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 90, // يمكنك تعديل الحجم كما تحب
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 8, 57, 97), // لون النص
              fontFamily: 'RobotoMono',
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: const Color.fromARGB(255, 34, 12, 112),
                  offset: Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 30.0,
                  color: Colors.greenAccent,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        // نستخدم Expanded لملء بقية الشاشة بالـGridView
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 0.8,
            ),
            itemCount: partsTitles.length,
            itemBuilder: (context, index) {
              return GamePartsCard(
                personalInfo: personalInfo,
                partTitle: partsTitles[index],
                imagePath: imagesPaths[index],
                partNumber: index + 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
