import 'dart:convert';
import 'package:http/http.dart' as http;

//link game:
class ApiService {
  static const String baseUrl =
      'http://192.168.100.2:5000'; // Replace with your PC's local IP

  static Future<String> checkLink(String link) async {
    if (link.isEmpty) {
      throw Exception('Link cannot be empty');
    }

    // Construct the URL with the link as a query parameter
    final url =
        Uri.parse('$baseUrl/check_link?link=${Uri.encodeComponent(link)}');

    // Make the GET request
    final response = await http.get(url);

    // Handle the response
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['result']; // Return the result directly
    } else {
      throw Exception('Failed to check link');
    }
  }
}
//password game

// API service for the password game

class ApiServicePasswordGame {
  static const String baseUrl =
      'http://192.168.100.2:5000'; // Replace with actual IP

  // Send both the password and personal info to the backend for validation
  static Future<String> checkPasswordAndInfo(
      String password, Map<String, String> personalInfo) async {
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    final url = Uri.parse('$baseUrl/check_password_and_info');
    final body = jsonEncode({
      'passwordKey': password,
      'InfoKey': personalInfo,
    });

    // Send a POST request with the password and personal info
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String strength = jsonResponse['strength'];

      // Ensure that the response contains a valid strength value
      if (strength == 'Strong' ||
          strength == 'Mid' ||
          strength == 'Weak' ||
          strength == 'You are using personal info') {
        return strength;
      } else {
        throw Exception('Unexpected strength value returned from the server');
      }
    } else if (response.statusCode == 400) {
      throw Exception(
          'Invalid request: Ensure that both password and personal information are provided');
    } else {
      throw Exception(
          'Failed to check password and personal information: ${response.statusCode}');
    }
  }
}
