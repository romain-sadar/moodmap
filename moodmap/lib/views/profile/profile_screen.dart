import 'dart:convert';

import 'package:flutter/material.dart';
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
  int _currentIndex = 0;
  String? username;
  String? id;
  bool isLoading = true; // Added loading state


  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Check if the user is logged in by verifying the id
  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      // Deserialize the user JSON
      Map<String, dynamic> userMap = json.decode(userJson);

      // Set the username and id from the user object
      setState(() {
        username = userMap['username'];
        id = userMap['id']; // Ensure 'id' is part of the user JSON
        isLoading = false;
      });
    } else {
      // Handle case where user is not found in SharedPreferences
      setState(() {
        isLoading = false;
      });
    }
  }


  // Function to switch between pages
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking user status
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Redirect to login if no id is found
    if (id == null) {
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
                  username ?? "User", // Fallback in case username is null
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_currentIndex == 0 ? "See my settings" : "See my dashboard"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _changePage(_currentIndex == 0 ? 1 : 0);
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
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
