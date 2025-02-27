import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/views/nav_layout.dart';
import 'package:moodmap/views/auth/login_screen.dart';
import 'package:moodmap/services/auth_service.dart';
import 'package:logger/logger.dart';


class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Logger logger = Logger();

  // Method to show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;

      var response = await AuthService.registerUser(name, email, password);

      if (response['statusCode'] == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavLayout()),
        );
      } else {
        _showErrorDialog(context, response['body']['message'] ?? 'Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              Text(
                "Register to MoodMap",
                style: AppTheme.textTheme.displaySmall,
              ),
              SizedBox(height: 32),

              // Name Field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: AppTheme.textTheme.bodyLarge,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(color: AppTheme.darkblue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(color: AppTheme.darkblue),
                  ),
                  floatingLabelStyle: TextStyle(color: AppTheme.darkblue),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Email Field
              TextFormField(
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
                    borderSide: BorderSide(color: AppTheme.darkblue),
                  ),
                  floatingLabelStyle: TextStyle(color: AppTheme.darkblue),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password Field
              TextFormField(
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
                    borderSide: BorderSide(color: AppTheme.darkblue),
                  ),
                  floatingLabelStyle: TextStyle(color: AppTheme.darkblue),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleRegister(context),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Divider with 'or'
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
              SizedBox(height: 16),

              // Google Sign-In Button (Icon Only)
              Center(
                child: IconButton(
                  onPressed: () {
                    // Handle Google Sign-In here when needed
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,  // Makes sure the Row is just large enough to fit the contents
                    children: [
                      SizedBox(width: 8), // Add spacing between the icon and the next image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,  // Makes the container round
                          border: Border.all(
                            color: Colors.black,  // Black border color
                            width: 1,  // Border width of 1px
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4),  // Optional: adds space between the image and the border
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

              // Login Redirect
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Already have an account? Click here to login",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkblue, // Blue color for the text
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
