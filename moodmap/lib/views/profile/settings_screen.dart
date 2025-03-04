import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/home_screen.dart';
import 'package:moodmap/views/home/widgets/listing_box.dart';
import 'package:moodmap/views/profile/informations_screen.dart';
import 'package:moodmap/views/profile/upgrade_plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/views/nav_layout.dart'; // Assuming you have a Login screen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isOnWeek = true;
  ListingItem item1 = ListingItem(
    photo: 'assets/images/brunchesCafe.jpg',
    label: 'Brunch Café',
    longitude: 0,
    latitude: 0,
    description: 'Cozy bruncher.',
    moods: ['Calm', 'Relax'],
    category: '☕️',
  );

  // Logout function
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear user data from SharedPreferences
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
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
                  onTap: _logout, // Call the logout function when tapped
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}