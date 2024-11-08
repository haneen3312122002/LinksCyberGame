import 'package:flutter/material.dart';
import 'DesBox.dart';
import 'DeviceHealth.dart';
import 'Mals.dart';
import 'Tools.dart';
import 'ToolsPabbel.dart';

class MalsGameScreen extends StatefulWidget {
  @override
  _MalwareGameScreenState createState() => _MalwareGameScreenState();
}

class _MalwareGameScreenState extends State<MalsGameScreen> {
  late Malware currentMalware;
  double deviceHealth = 1.0;
  List<Tool> tools = [Antivirus(), AntiWorm(), AntiSpyware()];

  @override
  void initState() {
    super.initState();
    loadNewMalware();
  }

  void loadNewMalware() {
    setState(() {
      currentMalware = ([Virus(), Worm(), Spyware()]..shuffle()).first;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("The device has been compromised!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                deviceHealth = 1.0;
                loadNewMalware();
              });
            },
            child: Text("Try Again"),
          ),
        ],
      ),
    );
  }

  void showMalwareDescription(Malware malware) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Malware Detected"),
        content: Text(malware.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void handleToolDrop(Tool tool, Malware malware) {
    setState(() {
      if ((tool is Antivirus && malware is Virus) ||
          (tool is AntiWorm && malware is Worm) ||
          (tool is AntiSpyware && malware is Spyware)) {
        loadNewMalware();
      } else {
        deviceHealth -= 0.2;
        if (deviceHealth <= 0) {
          deviceHealth = 0;
          showGameOverDialog();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text("Malware Identification Game"),
        backgroundColor: Colors.grey[850],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Score: ${(1.0 - deviceHealth) * 5}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: DeviceHealthIndicator(health: deviceHealth),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Malware Threats",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DragTarget<Tool>(
                      builder: (context, candidateData, rejectedData) =>
                          IconButton(
                        icon: Icon(Virus().icon, size: 40),
                        onPressed: () => showMalwareDescription(Virus()),
                      ),
                      onAccept: (tool) => handleToolDrop(tool, Virus()),
                    ),
                    DragTarget<Tool>(
                      builder: (context, candidateData, rejectedData) =>
                          IconButton(
                        icon: Icon(Worm().icon, size: 40),
                        onPressed: () => showMalwareDescription(Worm()),
                      ),
                      onAccept: (tool) => handleToolDrop(tool, Worm()),
                    ),
                    DragTarget<Tool>(
                      builder: (context, candidateData, rejectedData) =>
                          IconButton(
                        icon: Icon(Spyware().icon, size: 40),
                        onPressed: () => showMalwareDescription(Spyware()),
                      ),
                      onAccept: (tool) => handleToolDrop(tool, Spyware()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Tools",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: Row(
              children: tools.map((tool) {
                return Draggable<Tool>(
                  data: tool,
                  feedback: ToolWindow(tool: tool),
                  childWhenDragging:
                      Opacity(opacity: 0.5, child: ToolWindow(tool: tool)),
                  child: ToolWindow(tool: tool),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolWindow extends StatelessWidget {
  final Tool tool;

  ToolWindow({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build, size: 30), // Adjust to the tool type
          Text(
            tool.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
