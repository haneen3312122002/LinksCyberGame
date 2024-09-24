import 'package:flutter/material.dart';
import 'PortBack.dart';
import 'protocol_ports_game.dart';

class port_game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor:
              const Color.fromARGB(255, 172, 212, 233), // تغيير لون ال AppBar
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.network_check), // أيقونة شبكة
              SizedBox(width: 10), // مسافة بين الأيقونة والنص
              Text('Port Protocol Game'),
            ],
          ),
          centerTitle: true, // وضع العنوان في الوسط
        ),
        body: Stack(
          children: [
            BackgroundImage(), // استدعاء الخلفية
            ProtocolPortsGame(), // استدعاء كلاس اللعبة
          ],
        ),
      ),
    );
  }
}
