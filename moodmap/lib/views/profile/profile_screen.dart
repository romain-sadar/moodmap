import 'package:flutter/material.dart';
import 'package:moodmap/core/services/auth_service.dart';
import 'package:moodmap/views/auth/login_screen.dart';
import 'package:moodmap/views/profile/dashboard_screen.dart';
import 'package:moodmap/views/profile/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  int _currentIndex = 0;
  String? username;
  String? email;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.containsKey('auth_token'); // Check if the token exists

    if (!isLoggedIn) {
      // If no token, navigate to the LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Proceed with fetching user info if logged in
      var userInfo = await _authService.getUserInfo();
      setState(() {
        username = userInfo?['username'] ?? "User";
        email = userInfo?['email'] ?? "";
        _isAuthenticated = true;
      });
    }
  }

  /// ✅ Switch between Dashboard & Settings
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      // If not logged in, show LoginScreen
      return LoginScreen();
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  username ?? "User",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(email ?? ""),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _changePage(_currentIndex == 0 ? 1 : 0),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  DashboardScreen(),
                  SettingsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
