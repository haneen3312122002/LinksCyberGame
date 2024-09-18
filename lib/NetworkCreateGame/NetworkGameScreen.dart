import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'NetworkPhoto.dart';

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NetworkBackground(),

          // You can add other widgets on top of the background here
        ],
      ),
    );
  }
}
