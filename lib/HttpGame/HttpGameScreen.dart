import 'package:flutter/material.dart';
import 'Photo.dart'; // Assuming this contains the GameScreen class

class HttpGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Moving Street',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Moving Street Game'),
        ),
        body: Stack(
          children: [
            VideoGame(), // The moving background or game canva
          ],
        ),
      ),
    );
  }
}
