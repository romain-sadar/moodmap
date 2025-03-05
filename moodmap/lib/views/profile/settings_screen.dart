import 'package:flutter/material.dart';
import 'package:moodmap/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/views/auth/login_screen.dart';
import 'package:moodmap/views/profile/upgrade_plan_screen.dart';
import 'package:moodmap/views/profile/informations_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      "My information",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileInfoScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 10),
                    Text(
                      "Upgrade my plan",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpgradeScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  // Perform logout using AuthService
                  await _authService.logout();

                  // Navigate to LoginScreen and remove `NavLayout` from the stack
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
