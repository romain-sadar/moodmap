import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moodmap/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static Future<Map<String, dynamic>> registerUser(String name, String email,
      String password) async {
    final url = ApiConfig.registerUrl;

    try {
      print("Registering user: $name, $email");
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': name,
          'email': email,
          'password': password,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return {
        'statusCode': response.statusCode,
        'body': json.decode(response.body),
      };
    } catch (e) {
      print("Error occurred: $e");
      return {
        'statusCode': 500,
        'body': {'message': 'An error occurred. Please try again later.'},
      };
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final url = ApiConfig.loginUrl;

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        // Convert JSON response into a User object
        print(responseData['user']);
        User user = User.fromJson(responseData['user']);

        // Save user data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(user.toJson()));

        // Save token securely
        final storage = FlutterSecureStorage();
        await storage.write(key: 'authToken', value: user.id);

        return {'statusCode': 200, 'body': user.toJson()};
      } else {
        return {
          'statusCode': response.statusCode,
          'body': json.decode(response.body),
        };
      }
    } catch (e) {
      print(e);
      return {
        'statusCode': 500,
        'body': {'message': 'An error occurred. Please try again later.'},
      };
    }
  }

  static Future<User?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = json.decode(userJson);
      return User.fromJson(userMap);
    }

    return null; // No user found
  }
}
