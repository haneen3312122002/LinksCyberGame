import 'package:cybergame/AdvanceCeypto/AdCryptoMaim.dart';
import 'package:cybergame/AntiVirusGame/AntiGame.dart';
import 'package:cybergame/MalGame/MalGameScreen.dart';
import 'package:cybergame/PasswordGame/PassVideo.dart';
import 'package:flutter/material.dart';
import 'package:cybergame/CarGame/CarMain.dart';
import 'package:cybergame/DoorsGame/DoorsMainVideo.dart';
import 'package:cybergame/LinksGame/LinksVideoScreen.dart';
import 'package:cybergame/NetworkCreateGame/NetworkGameScreen.dart';
import 'package:cybergame/TrojanHorse/TrojanHorseGame.dart';
import 'package:cybergame/portGame/port_game.dart';
import 'package:cybergame/PasswordGame/CryptoGameScreen.dart';
import 'package:cybergame/MarioGame/MarioScreen.dart';
import 'package:flame/game.dart';
import 'package:cybergame/GalaxyGame/GalaxyGameScreen.dart';
import 'package:cybergame/GalaxyGame/ConnectVirusGame.dart';

class GamePartsCard extends StatelessWidget {
  final String partTitle; // عنوان الجزء أو اللعبة
  final String imagePath; // مسار الصورة المرتبطة بالجزء
  final int partNumber; // رقم الجزء للتمييز بين الشاشات المختلفة

  GamePartsCard({
    required this.partTitle,
    required this.imagePath,
    required this.partNumber,
  });

  // يقوم بتحديد واجهة اللعبة المناسبة بناءً على `partNumber`
  void navigateToPart(BuildContext context) {
    switch (partNumber) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NetworkGameScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PassVideoScreen()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DoorsVideoScreen()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LinksVideoScreen()));
        break;
      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MarioGameScreen()));
        break;
      case 6:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AdCryptoGame()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrojanHorseGame()));
        break;
      case 8:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AntiGameScreen()));
        break;
      case 10:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MalsGameScreen()));
        break;
      case 9:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConnectDotsGame()));
        break;
      case 12:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => port_game()));
        break;
      case 13:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CarGameScreen()));
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(partTitle)),
              body: Center(child: Text('Content for $partTitle')),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد القياسات بناءً على الشاشة
    double screenWidth = MediaQuery.of(context).size.width;
    double circleDiameter = screenWidth * 0.2; // قطر الدائرة بنسبة ثابتة
    double containerWidth = screenWidth * 0.5; // تقليل عرض المربع إلى 50%
    double containerHeight = 40; // تقليل ارتفاع المربع

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(),
          // الدائرة التي تحتوي على الصورة
          Container(
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              border: Border.all(
                  color: Colors.yellow, width: 2), // إضافة حدود للدائرة
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10), // مسافة صغيرة بين الدائرة والمربع

          // المربع الذي يحتوي على النص فقط
          Container(
            width: containerWidth,
            height: containerHeight,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 38, 179, 255),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.yellow, width: 2),
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
                navigateToPart(context);
              },
              child: Center(
                child: Text(
                  partTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
