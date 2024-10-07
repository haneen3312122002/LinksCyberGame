import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

//control data box
class DataDescriptionBox extends StatefulWidget {
  final Function(String) onDataGenerated;

  const DataDescriptionBox({required this.onDataGenerated, Key? key})
      : super(key: key);

  @override
  DataDescriptionBoxState createState() => DataDescriptionBoxState();
}

class DataDescriptionBoxState extends State<DataDescriptionBox> {
  String currentData = '';
  String correctProtocol = '';
  final audioPlayer = AudioPlayer();
  List<Map<String, String>> dataOptions = [
    {'data': 'بث مباشر لفيديو', 'protocol': 'UDP'}, // بث فيديو يتطلب UDP
    {
      'data': 'رسائل بريد إلكتروني',
      'protocol': 'TCP'
    }, // البريد الإلكتروني يتطلب TCP
    {
      'data': 'اتصال صوتي عبر الإنترنت',
      'protocol': 'UDP'
    }, // الاتصال الصوتي يستخدم UDP
    {'data': 'نقل ملفات كبيرة', 'protocol': 'TCP'}, // نقل الملفات يتطلب TCP
    {
      'data': 'ألعاب فيديو عبر الإنترنت',
      'protocol': 'UDP'
    }, // الألعاب تحتاج UDP
    {'data': 'تحميل صفحة ويب', 'protocol': 'TCP'}, // صفحات الويب تستخدم TCP
    {
      'data': 'نقل بيانات مستشعرات في الوقت الفعلي',
      'protocol': 'UDP'
    }, // المستشعرات تتطلب UDP
    {
      'data': 'تحميل البرامج والتحديثات',
      'protocol': 'TCP'
    }, // التحديثات تتطلب TCP
    {'data': 'بث مباشر للصوت', 'protocol': 'UDP'}, // بث الصوت
    {'data': 'مكالمات فيديو', 'protocol': 'UDP'}, // مكالمات الفيديو تحتاج UDP
    {'data': 'تصفح الإنترنت', 'protocol': 'TCP'}, // التصفح يحتاج TCP
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => generateRandomData());
  }

  // جعل الدالة عامة حتى يتم استدعاؤها من الخارج
  void generateRandomData() {
    if (dataOptions.isEmpty) {
      print("All questions are answered correctly!");
      return;
    }
    final random = Random();
    int index = random.nextInt(dataOptions.length);
    final randomItem =
        dataOptions.removeAt(index); // إزالة العنصر المستخدم من القائمة
    setState(() {
      currentData = randomItem['data']!;
      correctProtocol = randomItem['protocol']!;
    });
    widget.onDataGenerated(
        correctProtocol); // إرسال البروتوكول الصحيح لـ GameScreen
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
