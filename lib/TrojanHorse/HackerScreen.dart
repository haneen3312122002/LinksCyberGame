import 'package:flutter/material.dart';

class HackerScreen extends StatefulWidget {
  final Function(String virusType) onVirusSend;

  HackerScreen({required this.onVirusSend});

  @override
  _HackerScreenState createState() => _HackerScreenState();
}

class _HackerScreenState extends State<HackerScreen> {
  String selectedVirusType = 'إتلاف الملفات';
  String disguiseOption = 'أيقونة ملف زائفة';
  String activationMethod = 'فوري';
  String virusMessage = '';
  String backgroundColor = 'أحمر';
  double fileSize = 1.0;

  final virusTypes = [
    'إتلاف الملفات',
    'حذف الملفات',
    'إبطاء النظام',
    'رسائل منبثقة'
  ];
  final disguiseOptions = ['أيقونة ملف زائفة', 'حجم الملف'];
  final activationMethods = ['فوري', 'مؤجل'];
  final backgroundOptions = ['أحمر', 'أخضر', 'أزرق', 'أسود'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenSize.width * 0.9,
            padding: EdgeInsets.all(screenSize.width * 0.02),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 10),
              image: DecorationImage(
                image: AssetImage('assets/desktop2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildUIComponents(screenSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildUIComponents(Size screenSize) {
    return [
      Text(
        'أداة إنشاء الفيروس',
        style:
            TextStyle(color: Colors.white, fontSize: screenSize.width * 0.06),
      ),
      SizedBox(height: screenSize.height * 0.02),
      buildDropDown('نوع الفيروس:', selectedVirusType, virusTypes, (newValue) {
        setState(() => selectedVirusType = newValue!);
      }),
      buildDropDown('طريقة التنكر:', disguiseOption, disguiseOptions,
          (newValue) {
        setState(() => disguiseOption = newValue!);
      }),
      buildSlider(screenSize),
      buildDropDown('طريقة التفعيل:', activationMethod, activationMethods,
          (newValue) {
        setState(() => activationMethod = newValue!);
      }),
      buildTextField(),
      buildDropDown('تغيير خلفية الشاشة:', backgroundColor, backgroundOptions,
          (newValue) {
        setState(() => backgroundColor = newValue!);
      }),
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            // Call onVirusSend with the selectedVirusType
            widget.onVirusSend(selectedVirusType);
          },
          child: Text(
            'حفظ وتشغيل الفيروس',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
  }

  Widget buildDropDown(String label, String currentValue, List<String> options,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: currentValue,
          dropdownColor: Colors.grey[800],
          isExpanded: true,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildSlider(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('حجم الملف:', style: TextStyle(color: Colors.white)),
        Slider(
          value: fileSize,
          min: 0.5,
          max: 10.0,
          divisions: 19,
          label: fileSize.toString(),
          onChanged: (newValue) {
            setState(() {
              fileSize = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إدخال رسالة الفيروس:', style: TextStyle(color: Colors.white)),
        TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[700],
            border: OutlineInputBorder(),
            hintText: 'أدخل رسالة التحذير هنا',
            hintStyle: TextStyle(color: Colors.white54),
          ),
          onChanged: (newValue) {
            setState(() {
              virusMessage = newValue;
            });
          },
        ),
      ],
    );
  }
}
