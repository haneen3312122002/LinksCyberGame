import 'package:flutter/material.dart';

class AdCryptoGame extends StatefulWidget {
  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<AdCryptoGame> {
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isKeyVisible = false;
  String _encryptedMessage = ""; // Holds the encrypted message for بتول
  String _decryptedMessage =
      ""; // Holds the decrypted message for بتول after decryption
  String _originalMessage = ""; // Holds the original message for حنين

  // Correct date for the encryption key
  final String correctDay = '12';
  final String correctMonth = '12';
  final String correctYear = '1983';

  // Check if the entered date is correct
  void _checkAnswer() {
    setState(() {
      if (_dayController.text == correctDay &&
          _monthController.text == correctMonth &&
          _yearController.text == correctYear) {
        _isKeyVisible = true; // Show key icon if correct
      } else {
        _isKeyVisible = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect date! Try again.')),
        );
      }
    });
  }

  // Encrypt and send the message
  void _sendEncryptedMessage() {
    if (_isKeyVisible) {
      setState(() {
        _originalMessage =
            _messageController.text; // Set original message for حنين
        _encryptedMessage = _encryptMessage(
            _messageController.text); // Set encrypted message for بتول
        _decryptedMessage =
            ""; // Reset decrypted message when a new message is sent
        _messageController.clear(); // Clear the input field after sending
      });
    }
  }

  // Simple encryption (shifts each character by 1)
  String _encryptMessage(String message) {
    return message
        .split('')
        .map((char) => String.fromCharCode(char.codeUnitAt(0) + 1))
        .join();
  }

  // Decrypt the message (shifts each character back by 1)
  void _decryptMessage() {
    setState(() {
      _decryptedMessage = _encryptedMessage
          .split('')
          .map((char) => String.fromCharCode(char.codeUnitAt(0) - 1))
          .join();
    });
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Chat Interfaces within Phone Frames
          Expanded(
            child: Row(
              children: [
                // First Phone Frame (حنين) showing the original message
                _buildPhoneFrame(
                  "حنين",
                  Colors.green[50]!,
                  Colors.green[200]!,
                  alignment: Alignment.bottomLeft,
                  message: _originalMessage.isNotEmpty
                      ? _originalMessage
                      : "No message",
                  isSender: true,
                ),
                // Second Phone Frame (بتول) with Decrypt Button
                _buildPhoneFrame(
                  "بتول",
                  Colors.blue[50]!,
                  Colors.blue[200]!,
                  alignment: Alignment.bottomLeft,
                  message: _decryptedMessage.isNotEmpty
                      ? _decryptedMessage
                      : _encryptedMessage.isNotEmpty
                          ? _encryptedMessage
                          : "Waiting for encrypted message...",
                  showDecryptButton: _encryptedMessage.isNotEmpty,
                  onDecrypt: _decryptMessage,
                ),
              ],
            ),
          ),
          // Input and Check Button Section
          Container(
            width: 150,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter Date", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                _buildTextField(_dayController, 'Day'),
                SizedBox(height: 10),
                _buildTextField(_monthController, 'Month'),
                SizedBox(height: 10),
                _buildTextField(_yearController, 'Year'),
                SizedBox(height: 20),
                IconButton(
                  icon: Icon(Icons.check, size: 30),
                  onPressed: _checkAnswer,
                ),
                if (_isKeyVisible)
                  Icon(
                    Icons.vpn_key,
                    size: 40,
                    color: Colors.amber,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneFrame(
    String name,
    Color bgColor,
    Color headerColor, {
    required Alignment alignment,
    required String message,
    bool showDecryptButton = false,
    VoidCallback? onDecrypt,
    bool isSender = false, // Determines if this is the sender's frame
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phone Header
            Container(
              padding: EdgeInsets.all(8),
              color: headerColor,
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                color: bgColor,
                child: Align(
                  alignment: alignment,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      if (isSender)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: "Type message...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send, color: Colors.green),
                              onPressed: _sendEncryptedMessage,
                            ),
                          ],
                        ),
                      // Decrypt Button (Only shown on بتول's side)
                      if (showDecryptButton && onDecrypt != null && !isSender)
                        IconButton(
                          icon: Icon(Icons.lock_open, color: Colors.blue),
                          onPressed: onDecrypt,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      width: 60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
