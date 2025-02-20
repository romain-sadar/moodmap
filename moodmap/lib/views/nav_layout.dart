import 'package:flutter/material.dart';
import 'package:moodmap/views/home/home_screen.dart';
import 'package:moodmap/views/home/widgets/navbar.dart';

class NavLayout extends StatefulWidget {
  @override
  _NavLayoutState createState() => _NavLayoutState();
}

class _NavLayoutState extends State<NavLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    // MoodScreen(),
    // FavoriteScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Affiche l'écran correspondant à l'index
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
