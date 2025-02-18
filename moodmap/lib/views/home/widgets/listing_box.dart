import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';

class ListingBox extends StatelessWidget {
  final ListingItem item;

  ListingBox({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: IntrinsicHeight( // Uniformise la hauteur des enfants
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Étire les enfants pour qu'ils aient la même hauteur
          children: [
            // Utilisation de Stack pour superposer le smiley sur le container
            Expanded(
              child: Stack(
                children: [
                  // Container principal (Image + Texte)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      color: Color(0xFFF6F6F6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        // Image à gauche avec coins arrondis
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                           item.imagePath,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Texte à droite de l’image
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,  ),
                                ),
                                Text(
                                  item.distance,
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle:FontStyle.italic ),
                                ),
                                Text(
                                  item.description,
                                  style: TextStyle( fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height:10),
                                Wrap(
                                  spacing: 5,
                                  children: item.tags.map((tag) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppTheme.blue, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(color: AppTheme.blue, fontWeight: FontWeight.bold, fontSize:12),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Smiley positionné en haut à droite
                  Positioned(
                    top: 8,  // Ajuste la position verticale
                    right: 10, // Ajuste la position horizontale
                    child: Text(
                      '☕️',
                      style: TextStyle(fontSize: 20), // Taille du smiley
                    ),
                  ),
                ],
              ),
            ),

            // Bouton Go collé à droite
            Container(
              width: 42, // Largeur fixe du bouton
              decoration: BoxDecoration(
                color:  AppTheme.blue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 20, 
                      color: Colors.black, 
                    ),
                    Text(
                      'Go',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
