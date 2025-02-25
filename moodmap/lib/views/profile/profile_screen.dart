import 'package:flutter/material.dart';
import 'package:moodmap/views/profile/dashboard_screen.dart';
import 'package:moodmap/views/profile/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  int _currentIndex = 0;  

  // Fonction pour changer de vue
  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
        body: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: Text(
                  "Alice Mathey",
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
                index: _currentIndex, // Utilisation de l'index actuel directement
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
