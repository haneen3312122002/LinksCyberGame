import 'package:flutter/material.dart';
import 'package:cybergame/PasswordGame/CryptoGameScreen.dart';
import 'package:cybergame/NetworkCreateGame/NetworkGameScreen.dart';
import 'package:cybergame/SessionLayerGame/SessionLayerScreen.dart'; // استيراد الكلاس الجديد

class NetworkGameSection extends StatelessWidget {
  final int index; // Index of the section

  NetworkGameSection({required this.index});

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
                color: Colors.green, // Temporary color for the circle
                border: Border.all(
                  color: Colors.yellow, // Use similar style as the rectangle
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
                child: Icon(Icons.photo,
                    size: circleDiameter / 2,
                    color: Colors.white), // Placeholder icon
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
                  // Navigate to NetworkGameScreen when index is 0 for "لعبة تركيب الشبكات"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NetworkGameScreen()),
                  );
                } else if (index == 1) {
                  // Navigate to SessionLayerScreen when index is 1 for "Session Layer Game"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SessionLayerScreen()),
                  );
                }
              },
              child: Center(
                child: Text(
                  index == 0
                      ? 'لعبة تركيب الشبكات'
                      : ' لعبة طبقة الجلسات ', // النص الجديد لجزء 2
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
