import 'package:flutter/material.dart';

class TunnelBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tunnel.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
