import 'package:flutter/material.dart';
import 'package:cybergame/CryptoGame/CryptoGameScreen.dart';

class CryptoGamesCard extends StatelessWidget {
  final String partTitle;

  CryptoGamesCard({required this.partTitle});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to make dimensions responsive
    double size =
        MediaQuery.of(context).size.width / 3; // Making card size responsive

    return InkWell(
      onTap: () {
        if (partTitle == 'Crypto wall game') {
          // Navigate to CryptoGameScreen when "Crypto wall game" is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CryptoGameScreen()),
          );
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.yellow,
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            partTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

//..................................................

class CryptoGamesGrid extends StatelessWidget {
  final List<String> partsTitles = [
    'Crypto wall game',
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
      padding: EdgeInsets.all(1),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two cards per row
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1, // Ensures cards are square
      ),
      itemCount: partsTitles.length,
      itemBuilder: (context, index) {
        return CryptoGamesCard(
            partTitle: partsTitles[index]); // Build each card
      },
    );
  }
}
