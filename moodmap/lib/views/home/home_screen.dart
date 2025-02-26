import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/activity_model.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/widgets/navbar.dart';
import 'widgets/listing_box.dart';
import 'widgets/map_view.dart';
import 'package:moodmap/core/services/place_service.dart';
import 'package:moodmap/repositories/place_repository.dart';

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
  List<ListingItem> items = [];

  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final PlaceRepository placeRepository = PlaceRepository(placeService: PlaceService());

  List<Activity> listingActivities = [
    Activity(
      photo: 'assets/images/activity1.jpg',
      label: 'Yoga Class',
      time: 60,
      description: 'Relax and stretch your body.',
      moods: ['Relax', 'Sport'],
      category: 'yoga',
    ),
    Activity(
      photo: 'assets/images/activity2.jpg',
      label: 'Live Music Night',
      time: 5,
      description: 'Enjoy live music with friends.',
      moods: ['Music', 'Social'],
      category: 'book',
    ),
  ];

  Future<void> fetchPlaces() async {
    try {
      List<ListingItem> fetchedItems = await placeRepository.getPlaces();
      setState(() {
        items = fetchedItems;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void onPlaceSelected(ListingItem selectedItem) {
    setState(() {
      items.removeWhere((item) => item.label == selectedItem.label);
      items.insert(0, selectedItem);
    });
    _sheetController.animateTo(
      0.21,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Stack(
            children: [
              MapScreen(onPlaceSelected: onPlaceSelected, places: items),
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
                              showListButton = currentSheetSize <= 0.1;
                              isOnMap = currentSheetSize <= 1;
                              showButtons = currentSheetSize == 1.0;
                            });
                            return true;
                          },
                          child: DraggableScrollableSheet(
                            controller: _sheetController,
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
                                    Expanded(
                                      child: items.isEmpty
                                          ? Center(child: CircularProgressIndicator())
                                          : ListView.builder(
                                              controller: scrollController,
                                              itemCount: isOnMap ? items.length : listingActivities.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                  child: ListingBox(
                                                    item: isOnMap ? items[index] : listingActivities[index],
                                                  ),
                                                );
                                              },
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.blue,
                              ),
                              onPressed: () {
                                _sheetController.animateTo(
                                  1.0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.list, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text("List", style: TextStyle(color: Colors.black)),
                                ],
                              ),
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