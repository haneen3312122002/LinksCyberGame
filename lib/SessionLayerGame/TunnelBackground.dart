import 'package:flutter/material.dart';

class TunnelBackground extends StatelessWidget {
  const TunnelBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/tunnel.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
