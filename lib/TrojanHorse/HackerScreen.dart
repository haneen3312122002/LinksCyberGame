import 'package:flutter/material.dart';

class HackerScreen extends StatefulWidget {
  final Function(String virusType) onVirusSend;
  final ValueNotifier<Color> backgroundColorNotifier; // للتحكم في لون الخلفية
  final ValueNotifier<bool>
      showFakeGoogleIconNotifier; // للتحكم في إظهار الأيقونة المزيفة

  HackerScreen({
    required this.onVirusSend,
    required this.backgroundColorNotifier,
    required this.showFakeGoogleIconNotifier,
  });

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

      // Dropdown for Virus Type
      buildDropDown('نوع الفيروس:', selectedVirusType, virusTypes, (newValue) {
        setState(() => selectedVirusType = newValue!);
      }),

      // Dropdown for Disguise Option
      buildDropDown('طريقة التنكر:', disguiseOption, disguiseOptions,
          (newValue) {
        setState(() {
          disguiseOption = newValue!;
          widget.showFakeGoogleIconNotifier.value =
              (newValue == 'أيقونة ملف زائفة'); // تحديث الأيقونة
        });
      }),

      // Slider for File Size
      buildSlider(screenSize),

      // Dropdown for Activation Method
      buildDropDown('طريقة التفعيل:', activationMethod, activationMethods,
          (newValue) {
        setState(() => activationMethod = newValue!);
      }),

      // TextField for Virus Message
      buildTextField(),

      // Dropdown for Background Color
      buildDropDown('تغيير خلفية الشاشة:', backgroundColor, backgroundOptions,
          (newValue) {
        setState(() {
          backgroundColor = newValue!;
          widget.backgroundColorNotifier.value =
              getColorFromString(newValue); // تحديث اللون
        });
      }),

      // Button to Send Virus Type
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, color: Colors.white),
          ),
          onPressed: () {
            widget.onVirusSend(selectedVirusType); // إرسال نوع الفيروس المحدد
          },
          child: Text(
            'حفظ وتشغيل الفيروس',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
  }

  // Dropdown widget builder
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

  // Slider widget for file size
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

  // TextField widget for virus message
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

  // Helper function to convert color name to Color object
  Color getColorFromString(String colorName) {
    switch (colorName) {
      case 'أحمر':
        return Colors.red;
      case 'أخضر':
        return Colors.green;
      case 'أزرق':
        return Colors.blue;
      case 'أسود':
        return Colors.black;
      default:
        return Colors.red;
    }
  }
}
