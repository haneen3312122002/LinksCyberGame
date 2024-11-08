import 'package:flutter/material.dart';
import 'Tools.dart';

class ToolSelectionPanel extends StatelessWidget {
  final List<Tool> tools;
  final Function(Tool) onToolSelected;

  ToolSelectionPanel({required this.tools, required this.onToolSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: tools.map((tool) {
        return ElevatedButton(
          onPressed: () => onToolSelected(tool),
          child: Text(tool.name),
        );
      }).toList(),
    );
  }
}
