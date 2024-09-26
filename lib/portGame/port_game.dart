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
              SizedBox(width: 10), // Spacing between icon and text
              Text('Port Protocol Game'),
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
