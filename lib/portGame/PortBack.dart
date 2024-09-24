import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/port.png'), // Ensure the path is correct
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
