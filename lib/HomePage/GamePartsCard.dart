import 'package:flutter/material.dart';
import 'package:cybergame/CryptoPart/CryptoHomePage.dart'; // Ensure CryptoHomePage is correctly imported

class GamePartsCard extends StatelessWidget {
  final String partTitle;

  GamePartsCard({required this.partTitle});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 3; // Responsive card size

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
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.blue.shade900, // Dark blue color
          borderRadius: BorderRadius.circular(10), // Rounded corners
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
//.................................

class CryptoGamesGrid extends StatelessWidget {
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
        crossAxisCount: 2, // Two cards per row
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1, // Keeps cards square
      ),
      itemCount: partsTitles.length,
      itemBuilder: (context, index) {
        return GamePartsCard(partTitle: partsTitles[index]);
      },
    );
  }
}
