import 'package:cybergame/AdvanceCeypto/AdCryptoMaim.dart';
import 'package:cybergame/AntiVirusGame/AntiGame.dart';
import 'package:cybergame/MalGame/MalGameScreen.dart';
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

class CryptoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: 'Cryptography');
  }
}

class NetworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: 'Networking');
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Welcome to $title',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class GamePartsCard extends StatelessWidget {
  final String partTitle;
  final String imagePath;
  final int partNumber;

  GamePartsCard({
    required this.partTitle,
    required this.imagePath,
    required this.partNumber,
  });

  void navigateToPart(BuildContext context) {
    switch (partNumber) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NetworkGameScreen()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CryptoGameScreen()));
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
      case 9:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MalsGameScreen()));
        break;
      case 10:
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
                builder: (context) => PlaceholderPage(title: partTitle)));
    }
  }

  @override
  Widget build(BuildContext context) {
    double circleDiameter = MediaQuery.of(context).size.width * 0.2;

    return Center(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: circleDiameter / 2,
            child: Container(
              width: circleDiameter,
              height: circleDiameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
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
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: circleDiameter + 20),
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 38, 179, 255),
                    borderRadius: BorderRadius.circular(15),
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
                      navigateToPart(context);
                    },
                    child: Center(
                      child: Text(
                        partTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
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
                        partNumber.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
    'assets/14back.png',
    'assets/15back.png',
    'assets/16back.png',
    'assets/17back.png',
    'assets/18back.png',
    'assets/19back.png',
    'assets/20back.png',
    'assets/20back.png',
    'assets/22back.png',
    'assets/23back.png',
    'assets/24back.png',
    'assets/25back.png',
  ];

  final List<String> partsTitles = [
    'ما هي الشبكات؟',
    'دعنا نضع كلمة سر قوية للشبكة',
    'الان لنطلب موقع على الويب',
    'الان لنتصفح الويب بامان ',
    'لنلقي نظرة على اساسيات التشفير ',
    'سنتعمق قليلا في التشفير ',
    'تعرف وانتبه من خطر الفايروسات ',
    'الان، كافح الفايروسات ',
    'ميز بين انواع الفايروسات ',
    'ابن جدار امن لشبكتك ',
    'جرب هجوم الDOS',
    'ما هي البروتوكولات والمنافذ؟',
    'بروتوكولات نقل البيانات ',
    'ما هو sql injection',
    'يرامج الفدية',
    'هجمات التصيد',
    'الهندسة الاجتماعية هي الاخطر',
    'القرصنة الاخلاقية',
    'احمي معلوماتك على الانترنت ',
    'لا للتنمر الالكتروني ',
    'قانون الجرائم الالكترونية',
    'الاستجابة للحوادث الالكترونية',
    'التحدي النهائي',
    'Security Audits',
    'User Training',
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
