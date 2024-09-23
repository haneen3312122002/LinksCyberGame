import 'dart:convert';
import 'package:http/http.dart' as http;

//link game:
class ApiService {
  static const String baseUrl =
      'http://192.168.100.100:5000'; // Replace with your PC's local IP

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
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to check link');
    }
  }
}
//password game

// API service for the password game
class ApiServicePasswordGame {
  static const String baseUrl =
      'http://192.168.100.100:5000'; // تأكد من استبدال الـ IP بالعنوان الخاص بك

  static Future<String> checkPassword(String password) async {
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    // Construct the URL with the password as a query parameter
    final url = Uri.parse(
        '$baseUrl/check_password?password=${Uri.encodeComponent(password)}');

    // إرسال الطلب باستخدام GET
    final response = await http.get(url);

    // معالجة الاستجابة
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      String strength = jsonResponse['strength'];

      // تأكد أن النتيجة تكون "Weak" أو "Mid" أو "Strong"
      if (strength == 'Strong' || strength == 'Mid' || strength == 'Weak') {
        return strength;
      } else {
        throw Exception('Unexpected strength value returned from the server');
      }
    } else if (response.statusCode == 400) {
      throw Exception('Invalid request: Password parameter is missing');
    } else {
      throw Exception('Failed to check password: ${response.statusCode}');
    }
  }
}
