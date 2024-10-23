import 'package:cybergame/DoorsGame/DoorsMainVideo.dart';
import 'package:cybergame/LinksGame/LinksVideoScreen.dart';
import 'package:flutter/material.dart';
import 'package:cybergame/HttpGame/HttpGameScreen.dart';
import 'package:cybergame/TrojanHorse/TrojanHorseGame.dart'; // Import TrojanHorseGameScreen

class WebGameSection extends StatelessWidget {
  final int index; // Index of the section

  WebGameSection({required this.index});

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
                  // Conditional image logic based on the index
                  index == 1
                      ? 'assets/trojenHorse.png' // Show trojenHorse.png for index 1
                      : index == 2
                          ? 'assets/doorback.png' // Show doorback.png for index 2
                          : index == 3
                              ? 'assets/linkback.png' // Show linkback.png for index 3
                              : 'assets/Street1.png', // Default image for other indices
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
                  // Navigate to HttpGameScreen when index is 0 for "لعبة حواجز الانترنت"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HttpGameScreen()),
                  );
                } else if (index == 1) {
                  // Navigate to TrojanHorseGame when index is 1 for "لعبة حصان طروادة"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrojanHorseGame()),
                  );
                } else if (index == 2) {
                  // Navigate to DoorsVideoScreen when index is 2 for "الابواب"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoorsVideoScreen()),
                  );
                } else if (index == 3) {
                  // Navigate to LinksVideoScreen when index is 3 for "لينكات"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LinksVideoScreen()),
                  );
                }
              },
              child: Center(
                child: Text(
                  index == 0
                      ? 'لعبة حواجز الانترنت '
                      : index == 1
                          ? 'لعبة حصان طروادة'
                          : index == 2
                              ? 'الابواب'
                              : index == 3
                                  ? 'لعبة فحص الروابط '
                                  : '',
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
