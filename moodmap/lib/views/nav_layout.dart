import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/views/home/home_screen.dart';
import 'package:moodmap/views/home/widgets/mood_form.dart';
import 'package:moodmap/views/home/widgets/mood_form_location.dart';
import 'package:moodmap/views/home/widgets/navbar.dart';

class NavLayout extends StatefulWidget {
  @override
  _NavLayoutState createState() => _NavLayoutState();
}

class _NavLayoutState extends State<NavLayout> {
  int _selectedIndex = 0;

  // Method to navigate to the home screen
  void _goToHome() {
    setState(() {
      _selectedIndex = 0; 
    });
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      HomeScreen(),
      MoodFormScreen(goToHome: _goToHome),
      // FavoriteScreen(),
      // ProfileScreen(),
    ]);
  }

 
  void _onItemTapped(int index) {
  if (index == 1) { 
    _showMoodDialog();
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}

void _showMoodDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:Colors.white,
        title: Text("What do you want to do?"),
       
        actions: [
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [TextButton(
            style: 
              TextButton.styleFrom(
                backgroundColor: AppTheme.blue,
                foregroundColor:  Colors.white,
                shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
              ),
            onPressed: () {
              Navigator.pop(context); 
              setState(() {
                _selectedIndex = 1; 
              });
            },
            child: Text("Fill a new form"),
          ),
          SizedBox(width: 5,),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.blue,
              foregroundColor: Colors.white,
              shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
            ),
            onPressed: () {
              Navigator.pop(context); 
              setState(() {
                _selectedIndex = 2; 
              });
            },
            child: Text("Review a place"),
          ),
        ],
          )
          ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], 
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onItemTapped,
      ),
    );
  }
}
