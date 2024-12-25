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
          // Form Container
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 153, 0, 255).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 125, 173, 255)
                            .withOpacity(0.4),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'البيانات الأساسية',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontFamily: 'RobotoMono',
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
                                passwordColor: Colors.grey,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        label: Text(
                          'التالي',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 132, 0, 255),
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
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: color),
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 197, 144, 255).withOpacity(0.5),
      ),
      style: TextStyle(color: Colors.white),
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
              gradient: LinearGradient(
                colors: [Colors.black, Colors.blueGrey.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                    color: const Color.fromARGB(255, 141, 154, 255)
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 171, 202, 255)
                            .withOpacity(0.5),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title with futuristic font
                      Text(
                        'انشاء كلمة مرور',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password Field
                      GestureDetector(
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
                              labelStyle: TextStyle(color: Colors.cyanAccent),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    BorderSide(color: Colors.cyanAccent),
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.cyanAccent),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 197, 144, 255)
                                      .withOpacity(0.5),
                            ),
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Confirm Password Field
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'كلمة مرورك',
                          labelStyle: TextStyle(color: Colors.cyanAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Colors.cyanAccent),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 197, 144, 255)
                              .withOpacity(0.5),
                        ),
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),

                      // Action Buttons Row
                      Row(
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
                                horizontal: 20.0,
                                vertical: 15.0,
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
                              prefs.setString('dob', personalInfo['dob'] ?? '');
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
                                  const Color.fromARGB(255, 145, 2, 255),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ],
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
