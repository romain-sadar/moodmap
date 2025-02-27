import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/views/auth/login_screen.dart';
import 'package:moodmap/views/auth/register_screen.dart';
import 'package:moodmap/views/nav_layout.dart';
import 'views/home/home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      // Fournit Riverpod à toute l'application
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Other theme properties here
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppTheme.darkblue, // Set the cursor color globally
        ),
      ),

     //home: RegisterScreen(),
     home: NavLayout(),
    );
  }
}
