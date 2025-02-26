import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/core/utils.dart';
import 'package:moodmap/models/activity_model.dart';

class ListingBox extends StatelessWidget {
  final dynamic item;  
  
  ListingBox({required this.item});

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: Icon(Icons.image, color: Colors.grey[600]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: IntrinsicHeight( 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            
            Expanded(
              child: Stack(
                children: [
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
                          child: item.photo != null && item.photo!.isNotEmpty
                              ? Image.network(
                                  item.photo!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder(); // Use a reusable placeholder method
                                  },
                                )
                              : _buildPlaceholder(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                
                                Text(
                                  item is Activity ? item.time.toString() : item.longitude.toString(),
                                  style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  item.description ?? "No description available",
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 5,
                                  children: (item.moods as List<String>).map((tag) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppTheme.blue, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(color: AppTheme.blue, fontWeight: FontWeight.bold, fontSize: 12),
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
                  Positioned(
                    top: 8,  
                    right: 10, 
                    child: Text(
                      item is Activity? getEmojiActivities(item.category):
                      getEmojiPlaces(item.category),
                      style: TextStyle(fontSize: 20), 
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
                     item is Activity? Icons.play_arrow :Icons.directions_walk,
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
