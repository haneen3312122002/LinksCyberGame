import 'package:flutter/material.dart';
import 'package:cybergame/GameParts/CryptoPart/CryptoHomePage.dart'; // Ensure CryptoHomePage is correctly imported
import '/GameParts/NetworkPart/NetworkHome.dart';

class GamePartsCard extends StatelessWidget {
  final String partTitle;
  final String imagePath; // Image path for each card

  GamePartsCard({required this.partTitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Fixed card dimensions
    double cardWidth = 100; // Fixed width
    double cardHeight = 100; // Fixed height to maintain aspect ratio

    return InkWell(
      onTap: () {
        if (partTitle == 'Crypto part' || partTitle == 'Part 1') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CryptoHomePage()),
          );
        } else if (partTitle == 'network games' || partTitle == 'Part 3') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NetworkHomePage()),
          );
        }
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

//........................................
class CryptoGamesGrid extends StatelessWidget {
  final List<String> imagesPaths = [
    'assets/Cryptographygame.png',
    'assets/webSecurityPart.png',
    'assets/netWorkPart.png',
    'assets/CyberAttackPart.png',
    'assets/MobileSecurityPart.png',
    'assets/CyberAttackPart.png',
    'assets/MobileSecurityPart.png',
    'assets/CyberAttackPart.png',
    'assets/MobileSecurityPart.png',
    'assets/Cryptographygame.png',
  ];

  final List<String> partsTitles = [
    'Crypto part',
    'Part 2',
    'network games',
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
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =
        screenWidth > 600 ? 4 : 3; // More columns for wider screens

    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 1,
      ),
      itemCount: partsTitles.length,
      itemBuilder: (context, index) {
        return GamePartsCard(
          partTitle: partsTitles[index],
          imagePath: imagesPaths[index],
        );
      },
    );
  }
}
