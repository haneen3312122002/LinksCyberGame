import 'dart:convert';
import 'package:http/http.dart' as http;

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
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to check link');
    }
  }
}
