import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/widgets/navbar.dart';
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
  bool isOnMap = true;
  bool showButtons = false;
  bool showListButton = false;
  double currentSheetSize = 0.4;
  int selectedIndex = 0;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController(); // Ajout du contrôleur

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ListingItem item1 = ListingItem(
      photo: 'assets/images/brunchesCafe.jpg',
      label: 'Coffee Shop',
      longitude: 0,
      latitude: 0,
      description: 'Perfect place for a coffee break.',
      moods: ['Café', 'Work'],
      category: '📚',
    );

    ListingItem item2 = ListingItem(
      photo: 'assets/images/brunchesCafe.jpg',
      label: 'Coffee Shop',
      longitude: 0,
      latitude: 0,
      description: 'Perfect place for a coffee break.',
      moods: ['Café', 'Work'],
      category: '📚',
    );
  ListingItem activity1 = ListingItem(
      photo: 'assets/images/brunchesCafe.jpg',
      label: 'Coffee Shop',
      longitude: 0,
      latitude: 0,
      description: 'Perfect place for a coffee break.',
      moods: ['Café', 'Work'],
      category: '📚',
    );

    ListingItem activity2 = ListingItem(
      photo: 'assets/images/brunchesCafe.jpg',
      label: 'Coffee Shop',
      longitude: 0,
      latitude: 0,
      description: 'Perfect place for a coffee break.',
      moods: ['Café', 'Work'],
      category: '📚',
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Stack(
            children: [
              MapScreen(),
              Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        NotificationListener<DraggableScrollableNotification>(
                          onNotification: (notification) {
                            setState(() {
                              currentSheetSize = notification.extent;

                              // Affichage du bouton si la liste est en bas
                              showListButton = currentSheetSize <= 0.1;
                              isOnMap= currentSheetSize<=1;
                              // Affichage des boutons de navigation si la liste est complètement ouverte
                              showButtons = currentSheetSize == 1.0;

                            });
                            return true;
                          },
                          child: DraggableScrollableSheet(
                            controller: _sheetController, // Assignation du contrôleur
                            initialChildSize: 0.4,
                            minChildSize: 0,
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
                                    if (showButtons)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isOnMap
                                                    ? AppTheme.blue
                                                    : Colors.grey,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isOnMap = true;
                                                });
                                              },
                                              child: Icon(Icons.map,
                                                  color: Colors.white),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: !isOnMap
                                                    ? AppTheme.violet
                                                    : Colors.grey,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  isOnMap = false;
                                                });
                                              },
                                              child: Icon(Icons.location_off,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Expanded(
                                      child: ListView(
                                        controller: scrollController,
                                        children: [
                                          if (isOnMap) ...[
                                            ListingBox(item: item1),
                                            SizedBox(height: 8),
                                            ListingBox(item: item2),
                                          ] else ...[
                                            ListingBox(item: activity1),
                                            SizedBox(height: 8),
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
                        if (showListButton)
                          Positioned(
                            bottom: 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor:  AppTheme.blue, ),
                              onPressed: () {
                                _sheetController.animateTo(
                                  1.0, 
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Row
                              (children:[Icon(Icons.list, color: Colors.black,),SizedBox(width:10), Text("List",  style: TextStyle(color: Colors.black),) ]),
                            ),
                          ),
                      ],
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
