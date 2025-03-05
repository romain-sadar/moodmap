import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/core/constants.dart';

class AuthService {
  final String baseUrl = AppConstants.apiBaseUrl;

  /// ✅ Login with email & password
Future<bool> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login/"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the required data is available before using it
      if (data["tokens"] == null || data["tokens"]["access"] == null || data["tokens"]["refresh"] == null) {
        throw Exception("Tokens not available in the response");
      }

      if (data["user"] == null || data["user"]["id"] == null) {
        throw Exception("User ID not available in the response");
      }

      // Store the access and refresh tokens
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", data["tokens"]["access"]);
      await prefs.setString("refresh_token", data["tokens"]["refresh"]);
      
      // Store the userId in preferences during login
      String userId = data["user"]["id"];
      await prefs.setString("user_id", userId);

      return true;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  } catch (e) {
    print("Login error: $e");
    return false;
  }
}



  /// ✅ Register a new user
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register/"),
        body: jsonEncode(userData),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Registration failed: ${response.body}");
      }
    } catch (e) {
      print("Registration error: $e");
      return false;
    }
  }

  /// ✅ Refresh the access token
  Future<bool> refreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString("refresh_token");
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse("$baseUrl/token/refresh/"),
        body: jsonEncode({"refresh": refreshToken}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString("access_token", data["access"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Token refresh error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token'); // Get the stored refresh token

    if (refreshToken == null) {
      throw Exception("No refresh token found");
    }

    // Send a POST request to the logout endpoint with the refresh token in the body
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout/'),
      headers: {
        'Content-Type': 'application/json', // Specify content type
      },
      body: '{"refresh_token": "$refreshToken"}', // Send the refresh token in the request body
    );

    if (response.statusCode == 200) {
      // Successfully logged out, clear the tokens
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
    } else {
      // Handle errors here
      throw Exception("Logout failed: ${response.body}");
    }
  }


  /// ✅ Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("access_token");
    return token != null;
  }

  /// ✅ Get the stored access token
  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  /// ✅ Fetch user info
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      String? token = await getAccessToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/profile/me/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch user info: ${response.body}");
      }
    } catch (e) {
      print("User info error: $e");
      return null;
    }
  }

  Future<bool> upgradeToPremium() async {
  try {
    String? token = await getAccessToken();
    if (token == null) return false;

    final response = await http.patch(
      Uri.parse("$baseUrl/profile/me/"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"premium": true}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Upgrade failed: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Error upgrading to premium: $e");
    return false;
  }
}

  /// ✅ Get the user ID of the currently authenticated user
  Future<String?> getUserId() async {
    try {
      String? token = await getAccessToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/profile/me/get-user-id/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["user_id"];
      } else {
        throw Exception("Failed to fetch user ID: ${response.body}");
      }
    } catch (e) {
      print("Error fetching user ID: $e");
      return null;
    }
  }


}
