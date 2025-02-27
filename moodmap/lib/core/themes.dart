import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs principales
  static const Color blue = Color(0xFFB3D6FF);
  static const Color darkblue = Color(0xFF007AFF);
  static const Color violet = Color(0xFFC3B1E1);
  static const Color black = Color(0xFF1F1F1F);

  // Thème de texte
  static TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Nunito Sans'),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Nunito Sans'),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Nunito Sans'),
    bodyLarge: TextStyle(fontSize: 14, fontFamily: 'Nunito Sans'),
    bodyMedium: TextStyle(fontSize: 12, fontFamily: 'Nunito Sans'),

  );


}
