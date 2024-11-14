import 'package:flutter/material.dart';
import 'GamePartsCard.dart';

class CryptoGamesGrid extends StatelessWidget {
  final List<String> imagesPaths = [
    'assets/netWorkPart.png',
    'assets/PartsPage.png',
    'assets/doorback.png',
    'assets/linkback.png',
    'assets/fiveback.png',
    'assets/sixback.png',
    'assets/viros.png',
    'assets/eightback.png',
    'assets/nineback.png',
    'assets/10back.png',
    'assets/11back.png',
    'assets/ports.png',
    'assets/carback.png',
  ];

  final List<String> partsTitles = [
    'ما هي الشبكات؟',
    'دعنا نضع كلمة سر قوية للشبكة',
    'الان لنطلب موقع على الويب',
    'الان لنتصفح الويب بامان',
    'لنلقي نظرة على اساسيات التشفير',
    'سنتعمق قليلا في التشفير',
    'تعرف وانتبه من خطر الفايروسات',
    'الان، كافح الفايروسات',
    'ميز بين انواع الفايروسات',
    'ابن جدار امن لشبكتك',
    'جرب هجوم الDOS',
    'ما هي البروتوكولات والمنافذ؟',
    'بروتوكولات نقل البيانات',
  ];

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
          partTitle: partsTitles[index],
          imagePath: imagesPaths[index],
          partNumber: index + 1,
        );
      },
    );
  }
}
