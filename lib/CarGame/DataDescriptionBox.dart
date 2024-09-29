import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DataDescriptionBox extends StatefulWidget {
  final Function(String) onDataGenerated;

  const DataDescriptionBox({required this.onDataGenerated, Key? key})
      : super(key: key);

  @override
  _DataDescriptionBoxState createState() => _DataDescriptionBoxState();
}

class _DataDescriptionBoxState extends State<DataDescriptionBox> {
  String currentData = '';
  String correctProtocol = '';
  final audioPlayer = AudioPlayer();
  List<Map<String, String>> dataOptions = [
    {'data': 'بث مباشر لفيديو', 'protocol': 'UDP'},
    {'data': 'رسائل بريد إلكتروني', 'protocol': 'TCP'},
    // إضافة المزيد من البيانات حسب الحاجة
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateRandomData());
  }

  void _generateRandomData() {
    if (dataOptions.isEmpty) {
      print("All questions are answered correctly!");
      // ربما يمكن إضافة إعادة التعيين أو التنقل إلى صفحة نتائج أو غير ذلك.
      return;
    }
    final random = Random();
    int index = random.nextInt(dataOptions.length);
    final randomItem = dataOptions.removeAt(index);
    setState(() {
      currentData = randomItem['data']!;
      correctProtocol = randomItem['protocol']!;
    });
    widget.onDataGenerated(correctProtocol);
  }

  Future<void> playSound(String fileName) async {
    await audioPlayer.play(AssetSource(fileName));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 230, 97, 8).withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'البيانات الحالية: $currentData\n',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 236, 229, 229)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
