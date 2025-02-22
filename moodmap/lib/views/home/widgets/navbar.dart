import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';

class NavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const NavBar({super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0; // Index de l'icône sélectionné

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        widget.onTabSelected(index);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.blue, 
      unselectedItemColor: AppTheme.blue,
      showSelectedLabels: false, 
      showUnselectedLabels: false,
      iconSize: 30,
      items: [ 
        BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 1 ? Icons.mood : Icons.mood_outlined),
          label: '',
        ),
         BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline),
          label: '',
        ),
         BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 3 ? Icons.person : Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}
