import 'package:flutter/material.dart';
import 'package:cybergame/CryptoPart/CryptoHomePage.dart'; // Ensure CryptoHomePage is correctly imported

class GamePartsCard extends StatelessWidget {
  final String partTitle;
  final String imagePath; // مسار الصورة لكل كرت

  GamePartsCard({required this.partTitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // تصغير الكرت بشكل ملحوظ
    double cardWidth =
        MediaQuery.of(context).size.width / 5; // جزء أصغر من العرض
    double cardHeight =
        MediaQuery.of(context).size.height / 6; // جزء أصغر من الطول

    return InkWell(
      onTap: () {
        if (partTitle == 'Crypto part' || partTitle == 'Part 1') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CryptoHomePage()),
          );
        }
      },
      child: Container(
        width: cardWidth, // تصغير عرض الكرت
        height: cardHeight, // تصغير طول الكرت
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // زوايا دائرية
          border: Border.all(
            color: Colors.yellow,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(imagePath), // تحميل الصورة حسب كل كرت
            fit: BoxFit.cover, // جعل الصورة تغطي الكرت بالكامل
          ),
        ),
      ),
    );
  }
}

//.................................

class CryptoGamesGrid extends StatelessWidget {
  // قائمة الصور لكل كرت بالترتيب المطلوب
  final List<String> imagesPaths = [
    'assets/Cryptographygame.png',
    'assets/webSecurityPart.png',
    'assets/netWorkPart.png',
    'assets/CyberAttackPart.png',
    'assets/MobileSecurityPart.png',
    'assets/CyberAttackPart.png', // يمكن تكرار الصور عند الحاجة
    'assets/MobileSecurityPart.png',
    'assets/CyberAttackPart.png', // يمكن تكرار الصور عند الحاجة
    'assets/MobileSecurityPart.png',
    'assets/Cryptographygame.png',
  ];

  final List<String> partsTitles = [
    'Crypto part',
    'Part 2',
    'Part 3',
    'Part 4',
    'Part 5',
    'Part 6',
    'Part 7',
    'Part 8',
    'Part 9',
    'Part 10',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // صف يحتوي على كرتين
        crossAxisSpacing: 5, // تباعد أفقي بين الكروت
        mainAxisSpacing: 5, // تباعد عمودي بين الكروت
        childAspectRatio: 1, // الحفاظ على تناسب الكروت
      ),
      itemCount: partsTitles.length,
      itemBuilder: (context, index) {
        return GamePartsCard(
          partTitle: partsTitles[index],
          imagePath: imagesPaths[index], // تعيين الصورة لكل كرت
        );
      },
    );
  }
}
