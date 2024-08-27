import 'package:flutter/material.dart';

class LinkCheckerScreen extends StatefulWidget {
  @override
  _LinkCheckerScreenState createState() => _LinkCheckerScreenState();
}

class LinkChecker {
  static Future<String> checkLink(String link) async {
    // هنا يمكنك وضع كود لفحص الرابط باستخدام البايثون أو أي طريقة أخرى
    // حالياً سنعيد رسالة ثابتة كمثال
    return 'الرابط آمن'; // يمكن تغيير هذه القيمة لاختبار الحالة الأخرى
  }
}

class _LinkCheckerScreenState extends State<LinkCheckerScreen> {
  final TextEditingController _linkController = TextEditingController();

  String result = '';

  void checkLink() async {
    String link = _linkController.text;

    // استخدام الوظيفة من الملف الآخر لفحص الرابط
    String linkResult = await LinkChecker.checkLink(link);

    setState(() {
      result = linkResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color boxColor;
    if (result == 'الرابط آمن') {
      boxColor = Colors.green;
    } else if (result == 'الرابط غير آمن') {
      boxColor = Colors.red;
    } else {
      boxColor = Colors.transparent;
    }

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            // اسم اللعبة في منتصف الصفحة من الأعلى
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(bottom: screenHeight * 0.06),
              child: Text(
                'فحص الروابط',
                style: TextStyle(
                  fontSize: screenHeight * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            // حقل إدخال الرابط
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: Offset(0, 4),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  hintText: 'أدخل الرابط هنا',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // زر فحص الرابط
            SizedBox(
              width: screenWidth * 0.5,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: checkLink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'افحص الرابط',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.025,
                      ),
                    ),
                    SizedBox(width: 7),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // عرض نتيجة الفحص
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  result,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight * 0.025,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
