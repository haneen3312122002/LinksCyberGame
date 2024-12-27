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
    'assets/doorback.png', // Add the new image
  ];

  final List<String> partsTitles = [
    'رحلة في عالم الشبكات',
    'هل كل الروابط امنة؟',
    'شارع الحروف الامنة',
    'لنتعرف على الفايروسات معا',
    'هل يمكن مكافحة الفايروسات؟',
    'انواع الفايروسات',
    'ما هي البروتوكولات والمنافذ؟',
    ' تحدي التواصل',
    'لنرى كيف ستتعامل مع حوادث الاختراق',

    // Add the new title
  ];

  Map<String, String> personalInfo; // Example personal info
  CryptoGamesGrid({required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 3;

    return GridView.builder(
      padding: EdgeInsets.all(20),
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
          // Pass the personal info to each card
        );
      },
    );
  }
}
