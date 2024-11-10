import 'package:flutter/material.dart';

void main() => runApp(VirusConnectGame());

class VirusConnectGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // قائمة الصور والأوصاف
  List<String> images = [
    'assets/Worm.png',
    'assets/TimeBumb.png',
    'assets/Botnet.png',
    'assets/Spyware.png',
    'assets/RansomV.png',
    'assets/DownloaderV.png',
    'assets/TrojanH.png',
    'assets/InfectionV.png',
  ];

  List<String> descriptions = [
    'عدوى فيروسية',
    'قنبلة منطقية',
    'شبكة بوتنت',
    'برمجية تجسس',
    'محمل خبيث',
    'هجوم فدية',
    'حصان طروادة',
    'دودة حاسوب',
  ];

  // خرائط للتوصيل الصحيح
  Map<String, String> matchingMap = {
    'assets/Worm.png': 'دودة حاسوب',
    'assets/TimeBumb.png': 'قنبلة منطقية',
    'assets/Botnet.png': 'شبكة بوتنت',
    'assets/Spyware.png': 'برمجية تجسس',
    'assets/RansomV.png': 'هجوم فدية',
    'assets/DownloaderV.png': 'محمل خبيث',
    'assets/TrojanH.png': 'حصان طروادة',
    'assets/InfectionV.png': 'عدوى فيروسية',
  };

  // قوائم لتتبع التوصيلات
  Map<String, Offset> imagePositions = {};
  Map<String, Offset> descriptionPositions = {};
  List<Line> lines = [];

  // متغيرات للتفاعل (جعلها قابلة للقيمة الفارغة)
  String? selectedImage;
  String? selectedDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لعبة توصيل الفيروسات'),
      ),
      body: Stack(
        children: [
          // واجهة اللعبة
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;

              List<Widget> widgets = [];

              // مواقع الصور
              List<Offset> imageOffsets = [
                Offset(0, height * 0.1),
                Offset(0, height * 0.3),
                Offset(0, height * 0.5),
                Offset(0, height * 0.7),
                Offset(0, height * 0.9),
                Offset(0, height * 0.2),
                Offset(0, height * 0.4),
                Offset(0, height * 0.6),
              ];

              // مواقع الأوصاف
              List<Offset> descriptionOffsets = [
                Offset(width - 150, height * 0.9),
                Offset(width - 150, height * 0.1),
                Offset(width - 150, height * 0.7),
                Offset(width - 150, height * 0.3),
                Offset(width - 150, height * 0.5),
                Offset(width - 150, height * 0.2),
                Offset(width - 150, height * 0.8),
                Offset(width - 150, height * 0.4),
              ];

              // إضافة الصور
              for (int i = 0; i < images.length; i++) {
                String image = images[i];
                Offset offset = imageOffsets[i];
                widgets.add(Positioned(
                  left: offset.dx,
                  top: offset.dy - 30,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = image;
                        if (selectedDescription != null) {
                          lines.add(Line(
                            imageKey: selectedImage!,
                            descriptionKey: selectedDescription!,
                          ));
                          selectedImage = null;
                          selectedDescription = null;
                        }
                      });
                    },
                    child: Image.asset(
                      image,
                      height: 60,
                    ),
                  ),
                ));
                imagePositions[image] = Offset(offset.dx + 30, offset.dy);
              }

              // إضافة الأوصاف
              for (int i = 0; i < descriptions.length; i++) {
                String description = descriptions[i];
                Offset offset = descriptionOffsets[i];
                widgets.add(Positioned(
                  left: offset.dx,
                  top: offset.dy - 15,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDescription = description;
                        if (selectedImage != null) {
                          lines.add(Line(
                            imageKey: selectedImage!,
                            descriptionKey: selectedDescription!,
                          ));
                          selectedImage = null;
                          selectedDescription = null;
                        }
                      });
                    },
                    child: Container(
                      width: 150,
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ));
                descriptionPositions[description] =
                    Offset(offset.dx, offset.dy);
              }

              return Stack(
                children: widgets,
              );
            },
          ),
          // رسم الخطوط
          CustomPaint(
            painter: LinePainter(lines, imagePositions, descriptionPositions),
            child: Container(),
          ),
          // زر التحقق
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: ElevatedButton(
              onPressed: () {
                int correct = 0;
                for (var line in lines) {
                  if (matchingMap[line.imageKey] == line.descriptionKey) {
                    correct++;
                  }
                }
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('نتيجة التوصيل'),
                    content: Text(
                        'قمت بتوصيل $correct من ${images.length} بشكل صحيح'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            lines.clear();
                          });
                        },
                        child: Text('إعادة المحاولة'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('حسناً'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('تحقق'),
            ),
          ),
        ],
      ),
    );
  }
}

// كلاس لتخزين التوصيلات
class Line {
  String imageKey;
  String descriptionKey;

  Line({required this.imageKey, required this.descriptionKey});
}

// كلاس لرسم الخطوط
class LinePainter extends CustomPainter {
  List<Line> lines;
  Map<String, Offset> imagePositions;
  Map<String, Offset> descriptionPositions;

  LinePainter(this.lines, this.imagePositions, this.descriptionPositions);

  @override
  void paint(Canvas canvas, Size size) {
    Paint correctPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    Paint wrongPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    for (var line in lines) {
      Offset? start = imagePositions[line.imageKey];
      Offset? end = descriptionPositions[line.descriptionKey];

      if (start != null && end != null) {
        // تحقق من التوصيل الصحيح
        if (matchingMap[line.imageKey] == line.descriptionKey) {
          canvas.drawLine(start, end, correctPaint);
        } else {
          canvas.drawLine(start, end, wrongPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// خريطة التوصيلات الصحيحة
Map<String, String> matchingMap = {
  'assets/Worm.png': 'دودة حاسوب',
  'assets/TimeBumb.png': 'قنبلة منطقية',
  'assets/Botnet.png': 'شبكة بوتنت',
  'assets/Spyware.png': 'برمجية تجسس',
  'assets/RansomV.png': 'هجوم فدية',
  'assets/DownloaderV.png': 'محمل خبيث',
  'assets/TrojanH.png': 'حصان طروادة',
  'assets/InfectionV.png': 'عدوى فيروسية',
};
