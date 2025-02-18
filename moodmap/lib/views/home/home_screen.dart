import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'widgets/listing_box.dart';
import 'widgets/map_view.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOnMap = true; // État pour savoir si on est sur la carte ou sur les activités
  bool showButtons = false; // Contrôle la visibilité des boutons
  double currentSheetSize = 0.3; // Taille actuelle du DraggableScrollableSheet

  @override
  Widget build(BuildContext context) {
    ListingItem item1 = ListingItem(
      imagePath: 'assets/images/brunchesCafe.jpg',
      title: 'Brunch Café',
      distance: '3km',
      description: 'Cozy bruncher.',
      tags: ['Calm', 'Relax'],
      type: '☕️',
    );

    ListingItem item2 = ListingItem(
      imagePath: 'assets/images/brunchesCafe.jpg',
      title: 'Coffee Shop',
      distance: '5km',
      description: 'Perfect place for a coffee break.',
      tags: ['Café', 'Work'],
      type: '☕️',
    );

    ListingItem activity1 = ListingItem(
      imagePath: 'assets/images/brunchesCafe.jpg',
      title: 'Lecture',
      distance: '2min',
      description: 'Cozy bruncher.',
      tags: ['Calm', 'Relax'],
      type: '☕️',
    );

    ListingItem activity2 = ListingItem(
      imagePath: 'assets/images/brunchesCafe.jpg',
      title: 'Top',
      distance: '1min',
      description: 'Perfect place for a coffee break.',
      tags: ['Café', 'Work'],
      type: '☕️',
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              MapScreen(),
              Column(
                children: [
                  // DraggableScrollableSheet
                  Expanded(
                    child: NotificationListener<DraggableScrollableNotification>(
                      onNotification: (notification) {
                        // Mise à jour de la taille actuelle du sheet
                       setState(() {
                        currentSheetSize = notification.extent;
                        
                        // Si le sheet est à sa taille maximale, on affiche les boutons
                        if (currentSheetSize == 1.0) {
                          showButtons = true;
                        } else {
                          isOnMap = true;
                          showButtons = false;
                        }
                      });
                        return true;
                      },
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.4,
                        minChildSize: 0.4,
                        maxChildSize: 1.0,
                        builder: (BuildContext context, scrollController) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Affichage des boutons "Map" et "Activities" si showButtons est true
                                if (showButtons)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isOnMap ? AppTheme.blue : Colors.grey,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),  
                                                bottomLeft: Radius.circular(20), 
                                                topRight: Radius.circular(0),  
                                                bottomRight: Radius.circular(0), 
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isOnMap = true;
                                            });
                                          },
                                          child: Icon(Icons.map, color: Colors.white),
                                        ),
                                        
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: !isOnMap ? AppTheme.violet : Colors.grey,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),  
                                                bottomLeft: Radius.circular(0), 
                                                topRight: Radius.circular(20),  
                                                bottomRight: Radius.circular(20), 
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isOnMap = false;
                                            });
                                          },
                                          child: Icon(Icons.location_off, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                // Liste des éléments sur la carte ou les activités
                                Expanded(
                                  child: ListView(
                                    controller: scrollController,
                                    children: [
                                      if (isOnMap) ...[
                                        ListingBox(item: item1),
                                        SizedBox(height:8),
                                        ListingBox(item: item2),
                                      ] else ...[
                                        ListingBox(item: activity1),
                                        SizedBox(height:8),
                                        ListingBox(item: activity2),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
