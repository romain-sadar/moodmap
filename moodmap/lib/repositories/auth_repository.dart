import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moodmap/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String baseUrl = "$API_BASE_URL/auth";

  /// ✅ Login with email & password
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return await _storeTokens(data["tokens"]["access"], data["tokens"]["refresh"]);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  /// ✅ Register a new user
  Future<bool> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      body: jsonEncode(userData),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Registration failed: ${response.body}");
    }
  }

  /// ✅ Refresh the access token
  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString("refresh_token");

    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/token/refresh/"),
      body: jsonEncode({"refresh": refreshToken}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return await _storeAccessToken(data["access"]);
    } else {
      return false;
    }
  }

  /// ✅ Store tokens in SharedPreferences
  Future<bool> _storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString("access_token", accessToken) &&
           await prefs.setString("refresh_token", refreshToken);
  }

  /// ✅ Store access token separately (used for refresh)
  Future<bool> _storeAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString("access_token", accessToken);
  }

  /// ✅ Logout user (clear tokens)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
    await prefs.remove("refresh_token");
  }

  /// ✅ Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") != null;
  }

  /// ✅ Get the stored access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }
}
