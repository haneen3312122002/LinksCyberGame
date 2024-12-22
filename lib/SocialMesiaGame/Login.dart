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
                image: AssetImage('assets/LogInBack.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'البيانات الأساسية',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Name Field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'الاسم',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person, color: Colors.purple),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Email Field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email, color: Colors.purple),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Phone Field
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone, color: Colors.purple),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 15),
                      // Date of Birth Field
                      TextField(
                        controller: dobController,
                        decoration: InputDecoration(
                          labelText: 'تاريخ الميلاد',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.cake, color: Colors.purple),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      SizedBox(height: 20),
                      // Next Button
                      ElevatedButton.icon(
                        onPressed: () {
                          // Collect user data and navigate to SecondPage
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
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
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
}

//....................................

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
    // Set the first TextField
    passwordController.text = password;
    // ALSO set the second TextField to display the passed password
    confirmPasswordController.text = password;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LogInBack.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إنشاء كلمة المرور',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Password Field with color
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
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: passwordColor),
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.purple),
                            ),
                            style: TextStyle(color: passwordColor),
                            obscureText: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      // Confirm Password Field
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.purple),
                        ),
                        obscureText: false,
                      ),
                      SizedBox(height: 20),
                      // Back Button AND NEW "Login" button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),

                          // NEW: Login button
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Store user data (personal info + password) in shared preferences
                              final prefs =
                                  await SharedPreferences.getInstance();

                              // Example of storing the personal info
                              prefs.setString(
                                  'name', personalInfo['name'] ?? '');
                              prefs.setString(
                                  'email', personalInfo['email'] ?? '');
                              prefs.setString('dob', personalInfo['dob'] ?? '');
                              // If you also want to store phone, do likewise:
                              // prefs.setString('phone', personalInfo['phone'] ?? '');

                              // Store the password from the text field
                              prefs.setString(
                                  'password', passwordController.text);

                              // Navigate to HomePage()
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            },
                            icon: Icon(Icons.login, color: Colors.white),
                            label: Text(
                              'تسجيل الدخول',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
