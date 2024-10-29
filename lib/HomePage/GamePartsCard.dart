import 'package:cybergame/CarGame/CarMain.dart';
import 'package:cybergame/DoorsGame/DoorsMainVideo.dart';
import 'package:cybergame/LinksGame/LinksVideoScreen.dart';
import 'package:cybergame/NetworkCreateGame/NetworkGameScreen.dart';
import 'package:cybergame/TrojanHorse/TrojanHorseGame.dart';
import 'package:cybergame/portGame/port_game.dart';
import 'package:cybergame/portGame/protocol_ports_game.dart';
import 'package:flutter/material.dart';
import 'package:cybergame/PasswordGame/CryptoGameScreen.dart';

// Placeholder pages for each part, which you can replace with actual pages later
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

// Continue creating a new class for each part like this...
// Add as many unique pages as needed.

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

  GamePartsCard(
      {required this.partTitle,
      required this.imagePath,
      required this.partNumber});

  // Function to navigate to a specific page based on part number
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
            MaterialPageRoute(builder: (context) => LinksVideoScreen()));
        break;
      case 7:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TrojanHorseGame()));
        break;
      case 12:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => port_game()));
        break;
      case 13:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CarGameScreen()));
        break;
      case 21:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CarGameScreen()));
        break;
      case 22:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DoorsVideoScreen()));
        break;
      case 23:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => port_game()));
        break;
      // Add more cases here for each part's unique page...
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
          // Main image circle
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
          // Title container with top-right number circle and navigation functionality
          Container(
            margin: EdgeInsets.only(top: circleDiameter + 20),
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Stack(
              children: [
                // Background title container
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
                      navigateToPart(context); // Navigate to the specific part
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
                // Number circle at the top right of the title container
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

// Main Grid Widget
class CryptoGamesGrid extends StatelessWidget {
  final List<String> imagesPaths =
      List.generate(25, (index) => 'assets/placeholder.png');
  final List<String> partsTitles = [
    'ما هي الشبكات؟', //a1
    'دعنا نضع كلمة سر قوية للشبكة', //a2
    'الان لنطلب موقع على الويب', //3
    'الان لنتصفح الويب بامان ', //a4
    'لنلقي نظرة على اساسيات التشفير ', //a5
    'سنتعمق قليلا في التشفير ', //6
    'تعرف وانتبه من خطر الفايروسات ', //a7
    'الان، كافح الفايروسات ', //8
    'ميز بين انواع الفايروسات ', //9
    'ابن جدار امن لشبكتك ', //10
    'جرب هجوم الDOS', //11

    'ما هي البروتوكولات والمنافذ؟', //12
    'بروتوكولات نقل البيانات  ', //13
    'ما هو sql injection', //14
    'يرامج الفدية', //15
    'هجمات التصيد', //16
    'الهندسة الاجتماعية هي الاخطر', //17
    'القرصنة الاخلاقية', //18
    'احمي معلوماتك على الانترنت ', //19
    'لا للتنمر الالكتروني ', //20
    'قانون الجرائم الالكترونية', //21
    'الاستجابة للحوادث الالكترونية', //22
    'التحدي النهائي', //23
    'Security Audits', //24
    'User Training' //25
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
          partNumber: index + 1, // Pass part number
        );
      },
    );
  }
}
