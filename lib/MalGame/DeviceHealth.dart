import 'package:flutter/material.dart';

class DeviceHealthIndicator extends StatelessWidget {
  final double health;

  DeviceHealthIndicator({required this.health});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Device Health"),
        LinearProgressIndicator(
          value: health,
          minHeight: 8,
          backgroundColor: Colors.red[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }
}
