import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      '127.0.0.1:5000'; // Replace with your Flask server IP and port

  // Function to send link to Flask and get the result
  static Future<String> checkLink(String link) async {
    final url = Uri.parse('$baseUrl/check_link');

    // Create the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'link': link}),
    );

    // Handle the response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to check link');
    }
  }
}
