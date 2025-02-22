import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
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
      
     home: NavLayout(),
    );
  }
}
