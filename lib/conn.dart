import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoGameScreen extends StatefulWidget {
  @override
  _CryptoGameScreenState createState() => _CryptoGameScreenState();
}

class _CryptoGameScreenState extends State<CryptoGameScreen> {
  bool isDrawerVisible = true;
  String solutionResult = '';

  // دالة إرسال الحل إلى Flask
  Future<void> _checkSolution() async {
    String solution = "your_solution"; // استبدل هذه القيمة بالحل الفعلي
    var url =
        Uri.parse('http://127.0.0.1:5000/check_solution?solution=$solution');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        solutionResult = data['result'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(solutionResult == 'correct' ? 'Correct' : 'Incorrect')),
        );
      });
    } else {
      print('Error Server Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: isDrawerVisible ? 3 : 4,
            child: Stack(
              children: [
                // باقي الواجهة
              ],
            ),
          ),
          if (isDrawerVisible)
            Expanded(
              flex: 1,
              child: Container(
                  // باقي الواجهة
                  ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkSolution,
        child: Icon(Icons.check),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
