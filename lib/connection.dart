import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For debugPrint (optional)

//link game:
class ApiService {
  static const String baseUrl =
      'http://192.168.100.35:5000'; // Replace with your PC's local IP

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

/// ---------------------------------------------------------------------------
/// Service class to handle calling the password-check endpoint
/// ---------------------------------------------------------------------------
class ApiServicePasswordGame {
  // Replace with the actual IP/port of your Flask server
  static const String baseUrl = 'http://192.168.100.35:5000';

  // Send both the password and personal info to the backend for validation
  static Future<String> checkPasswordAndInfo(
    String password,
    Map<String, String> personalInfo,
  ) async {
    // Basic validation
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    final url = Uri.parse('$baseUrl/check_password_and_info');

    final body = jsonEncode({
      'passwordKey': password,
      'InfoKey': personalInfo,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String strength = jsonResponse['strength'];

        // Check for known strength values
        if (strength == 'Strong' ||
            strength == 'Mid' ||
            strength == 'Weak' ||
            strength == 'You are using personal info') {
          return strength;
        } else {
          throw Exception(
            'Unexpected strength value returned from the server: $strength',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception(
          'Invalid request: Ensure that both password and personal info are provided',
        );
      } else {
        throw Exception(
          'Failed to check password and personal information. '
          'Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error occurred while validating the password: $e');
    }
  }
}

//......................mario game api


// api_service.dart

class MarioApiService {
  static Future<bool> compareWord({
    required String collectedWord,
    required String displayedWord,
    required int key,
  }) async {
    final Map<String, dynamic> data = {
      'collected_word': collectedWord,
      'displayed_word': displayedWord,
      'key': key,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.209.100.35/compare_word'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        bool result = responseData['result'];
        return result;
      } else {
        // Handle server error
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      throw Exception('Network error: $e');
    }
  }
}
//..........................

Future<String> analyzeComment(String comment) async {
  final url = Uri.parse('http://192.168.100.35:5000/classify_message');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': comment}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('Raw analyzeComment response: $data');
      final sentiment = (data['category'] ?? '').toString().trim(); // ✅ الكلمة الصحيحة هي category
      debugPrint('Final sentiment value: "$sentiment"');
      return sentiment;
    } else {
      print("Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception('Failed to analyze comment (status != 200).');
    }
  } catch (e) {
    print("Error during HTTP request: $e");
    throw Exception('Failed to connect to the server or parse response.');
  }
}
//............................

class ReportApiService {
  final String baseUrl;

  // Constructor: Pass the API base URL
  ReportApiService({required this.baseUrl});

  // Method to classify a message
  Future<String> classifyMessage(String message) async {
    final url = Uri.parse('$baseUrl/classify_message');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['category']; // Return the classified category
      } else {
        print('Error Response: ${response.body}');
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Connection Error: $e');
      return 'Error: Failed to connect to the API. $e';
    }
  }
}
