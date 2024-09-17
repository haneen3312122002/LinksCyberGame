import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ConnectionPoint {
  Offset position;
  Color color;
  bool isSelected = false;

  ConnectionPoint(this.position, {this.color = Colors.grey});
}

class Connection {
  ConnectionPoint start;
  ConnectionPoint end;
  Color color;

  Connection(this.start, this.end, this.color);
}

class NetworkPainter extends CustomPainter {
  List<Connection> connections;

  NetworkPainter(this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (var connection in connections) {
      paint.color = connection.color;
      canvas.drawLine(
          connection.start.position, connection.end.position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NetworkGameScreen extends StatefulWidget {
  @override
  _NetworkGameScreenState createState() => _NetworkGameScreenState();
}

class _NetworkGameScreenState extends State<NetworkGameScreen> {
  Color currentColor = Colors.red;
  List<ConnectionPoint> points = [
    ConnectionPoint(Offset(100, 100), color: Colors.red),
    ConnectionPoint(Offset(200, 300), color: Colors.blue),
    ConnectionPoint(Offset(300, 500), color: Colors.green), // Add more points
  ];

  List<Connection> connections = [];
  ConnectionPoint? tempStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            // Loop through points to check if a point is touched
            for (var point in points) {
              if ((details.localPosition - point.position).distance < 20) {
                if (tempStart == null) {
                  tempStart = point; // Set start of new connection
                } else if (tempStart != point) {
                  connections.add(Connection(tempStart!, point, currentColor));
                  tempStart =
                      point; // Reset tempStart to the end point, allowing a new connection from this point
                }
                break;
              }
            }
          });
        },
        onPanEnd: (details) {
          setState(() {
            tempStart = null; // Reset after the touch gesture ends
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/NetworkBackground.png',
                fit: BoxFit.cover,
              ),
            ),
            CustomPaint(
              painter: NetworkPainter(connections),
              child: Container(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Draw interactive points
            ...points.map((point) => Positioned(
                  left: point.position.dx - 15,
                  top: point.position.dy - 15,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        point.isSelected = !point.isSelected;
                        if (point.isSelected && tempStart == null) {
                          tempStart = point;
                        } else if (tempStart != null && tempStart != point) {
                          connections
                              .add(Connection(tempStart!, point, currentColor));
                          tempStart = null;
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          point.isSelected ? Colors.green : Colors.transparent,
                    ),
                  ),
                )),
            // Color selection buttons
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Button for Red color
                    FloatingActionButton(
                      heroTag: 'redFab', // Unique heroTag for the red button
                      backgroundColor: Colors.red,
                      onPressed: () =>
                          setState(() => currentColor = Colors.red),
                      child: Icon(Icons.lens, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    // Button for Blue color
                    FloatingActionButton(
                      heroTag: 'blueFab', // Unique heroTag for the blue button
                      backgroundColor: Colors.blue,
                      onPressed: () =>
                          setState(() => currentColor = Colors.blue),
                      child: Icon(Icons.lens, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
