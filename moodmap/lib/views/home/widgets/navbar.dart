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
  

  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
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
          icon: Icon(widget.selectedIndex == 0 ? Icons.home : Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: widget.selectedIndex == 1 
              ? Image.asset(
                  'assets/images/mood.png', 
                  width: 30,
                  height: 30,
                )
              : Icon(Icons.mood), 
          label: '',
        ),
         BottomNavigationBarItem(
          icon: Icon(widget.selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline),
          label: '',
        ),
         BottomNavigationBarItem(
          icon: Icon(widget.selectedIndex == 3 ? Icons.person : Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}
