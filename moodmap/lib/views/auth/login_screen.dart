import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/views/nav_layout.dart';
import 'package:moodmap/views/auth/register_screen.dart';
import 'package:moodmap/services/auth_service.dart';

final Logger logger = Logger();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      logger.i("Attempting login...");
      logger.d("Email: ${emailController.text.trim()}");
      logger.d("Password: ${passwordController.text.trim()}"); // Remove this in production

      final response = await AuthService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      logger.i("Response received: $response");

      setState(() {
        isLoading = false;
      });

      if (response['statusCode'] == 200) {
        logger.i("Login successful. Navigating to NavLayout...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavLayout()),
        );
      } else {
        setState(() {
          errorMessage = response['body']['message'] ?? 'Login failed. Try again.';
        });
        logger.e("Login failed: $errorMessage");
      }
    } catch (e, stackTrace) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred. Please try again.';
      });
      logger.e("Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 64),
            Text(
              "Login to MoodMap",
              style: AppTheme.textTheme.displaySmall,
            ),
            SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: AppTheme.textTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                floatingLabelStyle: TextStyle(color: Colors.black),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: AppTheme.textTheme.bodyLarge,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                floatingLabelStyle: TextStyle(color: Colors.black),
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "or",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.1,
                  ),
                ),
              ],
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  // Handle Google Sign-In when needed
                },
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/glogo.png',
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text(
                  "Not registered yet? Click here to create an account",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkblue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}