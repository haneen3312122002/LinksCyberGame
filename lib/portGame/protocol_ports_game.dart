import 'package:flutter/material.dart';

class ProtocolPortsGame extends StatefulWidget {
  @override
  _ProtocolPortsGameState createState() => _ProtocolPortsGameState();
}

class _ProtocolPortsGameState extends State<ProtocolPortsGame> {
  final Map<String, int> protocolsPorts = {
    'HTTP': 80,
    'HTTPS': 443,
    'TCP': 6,
    'UDP': 17,
    'FTP': 21,
    'DNS': 53,
    'SMTP': 25,
    'IMAP': 143,
    'SSH': 22,
    'Telnet': 23,
  };

  Map<String, String> userAnswers = {};
  Map<String, Color> fieldColors = {};

  @override
  void initState() {
    super.initState();
    protocolsPorts.forEach((protocol, port) {
      userAnswers[protocol] = '';
      fieldColors[protocol] = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProtocolColumns(),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _checkAllAnswers,
                    child: Text('Check All Answers'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolColumns() {
    var halfLength = (protocolsPorts.length / 2).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildProtocolColumn(0, halfLength)),
        Expanded(
            child: _buildProtocolColumn(halfLength, protocolsPorts.length)),
      ],
    );
  }

  Widget _buildProtocolColumn(int start, int end) {
    List<String> protocols = protocolsPorts.keys.toList();
    return Column(
      children: protocols.sublist(start, end).map((protocol) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  protocol,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      userAnswers[protocol] = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fieldColors[protocol],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Port',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _checkAllAnswers() {
    setState(() {
      protocolsPorts.forEach((protocol, correctPort) {
        int userPort = int.tryParse(userAnswers[protocol]!) ?? 0;
        if (userPort == correctPort) {
          fieldColors[protocol] = Colors.green;
        } else {
          fieldColors[protocol] = Colors.red;
        }
      });
    });
  }
}
