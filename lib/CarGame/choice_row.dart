import 'package:flutter/material.dart';
import 'transparent_container.dart';

//containar class
class ChoiceRow extends StatelessWidget {
  final VoidCallback onTcpSelected;
  final VoidCallback onUdpSelected;

  ChoiceRow({
    required this.onTcpSelected,
    required this.onUdpSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // كونتينار UDP على اليسار
        GestureDetector(
          onTap: onUdpSelected,
          child: TransparentContainer(label: 'UDP'),
        ),
        // كونتينار TCP على اليمين
        GestureDetector(
          onTap: onTcpSelected,
          child: TransparentContainer(label: 'TCP'),
        ),
      ],
    );
  }
}
