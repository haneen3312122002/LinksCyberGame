import 'package:flutter/material.dart';
import 'PortBack.dart';
import 'protocol_ports_game.dart';

class port_game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove the AppBar shadow
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.network_check), // Network Icon
              SizedBox(width: 8), // Spacing between icon and text
              Text(
                'Port Protocol Game',
                style: TextStyle(
                  fontSize: 35, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                  color: const Color.fromARGB(255, 12, 23, 85), // Text color
                  letterSpacing: 1.5, // Add some letter spacing
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2.0, 2.0),
                    ),
                  ], // Adding shadow to make text stand out
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true, // Extend the body behind the AppBar
        body: Stack(
          children: [
            SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/portBack.png'), // Ensure the path is correct
                    fit: BoxFit.cover, // Covers the entire screen
                  ),
                ),
              ),
            ),
            ProtocolPortsGame(), // Game logic overlaying the background
          ],
        ),
      ),
    );
  }
}
