import 'package:flutter/material.dart';
import 'package:cybergame/PasswordGame/CryptoGameScreen.dart';
import 'package:cybergame/NetworkCreateGame/NetworkGameScreen.dart';
import 'package:cybergame/CarGame/CarMain.dart'; // استيراد شاشة CarMain

class CryptoGameSection extends StatelessWidget {
  final int index; // Index of the section

  CryptoGameSection({required this.index});

  @override
  Widget build(BuildContext context) {
    // Determine the size of the circle based on the screen size
    double circleDiameter = MediaQuery.of(context).size.width *
        0.3; // Circle diameter as 30% of screen width

    return Center(
      child: Stack(
        alignment: AlignmentDirectional
            .topCenter, // Align children along the vertical center
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6 -
                circleDiameter, // Position to overlap the rectangle
            child: Container(
              width: circleDiameter,
              height: circleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green, // Temporary background color
                border: Border.all(
                  color: Colors.yellow, // Border style
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
              child: ClipOval(
                child: Image.asset(
                  'assets/casel.png', // Path to your image
                  fit: BoxFit.cover, // Fit image to cover the circle
                  width: circleDiameter,
                  height: circleDiameter,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            width:
                MediaQuery.of(context).size.width * 0.6, // 60% of screen width
            height: MediaQuery.of(context).size.height *
                0.2, // 20% of screen height
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 38, 179, 255),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.yellow, width: 3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  // Navigate to CryptoGameScreen when index is 0 for "لعبة جدار كلمة المرور"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                } else if (index == 1) {
                  // Navigate to CarMain screen when index is 1 for "لعبة السيارات"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CryptoGameScreen()),
                  );
                }
              },
              child: Center(
                child: Text(
                  index == 0
                      ? 'لعبة جدار كلمة المرور'
                      : index == 1
                          ? 'لعبة السيارات'
                          : 'Part ${index + 1}', // Display custom text for other parts
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
