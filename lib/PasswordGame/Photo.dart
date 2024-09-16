import 'package:flutter/material.dart';

class BackgroundPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/casel.png'), // Ensure the image exists
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
