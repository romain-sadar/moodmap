import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey[300],  // Carré gris
          width: double.infinity,  // Prend toute la largeur
          height: double.infinity,  // Hauteur fixe
        ),
      ),
    );
  }
}
