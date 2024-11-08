import 'package:flutter/material.dart';
import 'DesBox.dart';
import 'Mals.dart';

class Tool {
  final String name;
  final Function(Malware) onApply;

  Tool(this.name, this.onApply);
}

class Antivirus extends Tool {
  Antivirus()
      : super("Antivirus", (malware) {
          if (malware is Virus) {
            print("Virus removed!");
          } else {
            print("Incorrect tool!");
          }
        });
}

class AntiWorm extends Tool {
  AntiWorm()
      : super("AntiWorm", (malware) {
          if (malware is Worm) {
            print("Worm removed!");
          } else {
            print("Incorrect tool!");
          }
        });
}

class AntiSpyware extends Tool {
  AntiSpyware()
      : super("AntiSpyware", (malware) {
          if (malware is Spyware) {
            print("Spyware removed!");
          } else {
            print("Incorrect tool!");
          }
        });
}
