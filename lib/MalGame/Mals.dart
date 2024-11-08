import 'package:flutter/material.dart';

abstract class Malware {
  final String description;
  final IconData icon; // Add an icon property
  Malware(this.description, this.icon);
}

class Virus extends Malware {
  Virus()
      : super("A file that keeps replicating itself across the device.",
            Icons.bug_report);
}

class Worm extends Malware {
  Worm()
      : super("A silent invader spreading through network vulnerabilities.",
            Icons.memory);
}

class Spyware extends Malware {
  Spyware()
      : super(
            "Unseen, it quietly watches and collects data.", Icons.visibility);
}
