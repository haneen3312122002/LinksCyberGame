import 'package:cybergame/PasswordGame/CryptoGameScreen.dart';
import 'package:flutter/material.dart';
import 'package:cybergame/PasswordGame/PassVideo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cybergame/HomePage/HomePage.dart';

class LoginPage extends StatelessWidget {
  // Controllers to capture user input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LoginBack.png'), // Use your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Neon Text on the left

          // Form Container aligned to the right
          Align(
            alignment: Alignment.centerRight, // Align to the right
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 160.0), // Adjust padding if needed
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'البيانات الأساسية',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 241, 238,
                              238), // White color for neon effect
                          fontFamily: 'RobotoMono',
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.white,
                              offset: Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 20.0,
                              color: Colors.white,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Name Field
                      _buildCyberField(
                        controller: nameController,
                        labelText: 'الاسم',
                        icon: Icons.person,
                        color: Colors.cyanAccent,
                      ),
                      SizedBox(height: 15),
                      // Email Field
                      _buildCyberField(
                        controller: emailController,
                        labelText: 'البريد الإلكتروني',
                        icon: Icons.email,
                        color: Colors.greenAccent,
                      ),
                      SizedBox(height: 15),
                      // Phone Field
                      _buildCyberField(
                        controller: phoneController,
                        labelText: 'رقم الهاتف',
                        icon: Icons.phone,
                        color: Colors.blueAccent,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 15),
                      // Date of Birth Field
                      _buildCyberField(
                        controller: dobController,
                        labelText: 'تاريخ الميلاد',
                        icon: Icons.cake,
                        color: Colors.orangeAccent,
                        keyboardType: TextInputType.datetime,
                      ),
                      SizedBox(height: 20),
                      // Next Button
                      ElevatedButton.icon(
                        onPressed: () {
                          final personalInfo = {
                            'name': nameController.text,
                            'email': emailController.text,
                            'dob': dobController.text,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondPage(
                                personalInfo: personalInfo,
                                password: '',
                                passwordColor:
                                    const Color.fromARGB(255, 122, 117, 117),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward,
                            color: const Color.fromARGB(255, 201, 193, 193)),
                        label: Text(
                          'التالي',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 11, 16, 78),
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 15.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Reusable Cyber-Themed Text Field
  Widget _buildCyberField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required Color color,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: 300, // Set your desired width here
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final Map<String, String> personalInfo;
  final String password;
  final Color passwordColor;

  // Accept personal info, password, and color from the previous page
  SecondPage({
    required this.personalInfo,
    required this.password,
    required this.passwordColor,
  });

  @override
  Widget build(BuildContext context) {
    passwordController.text = password;
    confirmPasswordController.text = password;

    return Scaffold(
      body: Stack(
        children: [
          // Futuristic Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LoginBack.png'), // Use your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Tech-style Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title with futuristic font
                      SizedBox(
                        width: 250, // Set a smaller width for the text
                        child: Text(
                          'إنشاء كلمة مرور',
                          textAlign: TextAlign.center, // Center-align the text
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 182, 178,
                                178), // White color for neon effect
                            fontFamily: 'RobotoMono',
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                              Shadow(
                                blurRadius: 20.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password Field
                      SizedBox(
                        width: 250, // Set a smaller width for the field
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to PassVideoScreen with personalInfo
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PassVideoScreen(
                                  personalInfo: personalInfo,
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                labelStyle: TextStyle(
                                    color: Colors.white), // White for text
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.white, // White neon border
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .white, // White neon border for enabled state
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .white, // White neon border for focused state
                                    width: 2.0,
                                  ),
                                ),
                                prefixIcon: Icon(Icons.lock,
                                    color: Colors.white), // White icon
                                filled: false, // Transparent background
                              ),
                              style: TextStyle(
                                  color: Colors.white), // White text color
                              obscureText: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Confirm Password Field
                      SizedBox(
                        width: 250, // Set a smaller width for the field
                        child: TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'تأكيد كلمة المرور',
                            labelStyle: TextStyle(
                                color: Colors.white), // White for text
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.white, // White neon border
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors
                                    .white, // White neon border for enabled state
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors
                                    .white, // White neon border for focused state
                                width: 2.0,
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Colors.white), // White icon
                            filled: false, // Transparent background
                          ),
                          obscureText: true,
                          style: TextStyle(
                              color: Colors.white), // White text color
                        ),
                      ),
                      SizedBox(height: 20),

                      // Action Buttons Row
                      SizedBox(
                        width: 250, // Make the row match the fields' width
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              label: Text(
                                'رجوع',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),

                            // Login Button
                            ElevatedButton.icon(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString(
                                    'name', personalInfo['name'] ?? '');
                                prefs.setString(
                                    'email', personalInfo['email'] ?? '');
                                prefs.setString(
                                    'dob', personalInfo['dob'] ?? '');
                                prefs.setString(
                                    'password', passwordController.text);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      personalInfo: personalInfo,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.login, color: Colors.white),
                              label: Text(
                                'تسجيل',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 11, 16, 78),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
