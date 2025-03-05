import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/widgets/navbar.dart';
import 'widgets/listing_box.dart';
import 'widgets/map_view.dart';
import 'package:moodmap/core/services/place_service.dart';
import 'package:moodmap/repositories/place_repository.dart';

class HomeScreen extends StatefulWidget {
  final String? selectedMood;

  const HomeScreen({super.key, this.selectedMood});

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
  List<String> selectedMoods = [];
  bool isLoading = false;

  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final PlaceRepository placeRepository = PlaceRepository(placeService: PlaceService());

  void fetchPlaces([String? mood]) {
    setState(() => isLoading = true);

    Future<List<ListingItem>> fetch = (mood == null || mood.isEmpty)
        ? placeRepository.getPlaces()
        : placeRepository.getPlacesByMood(mood);

    fetch.then((places) {
      setState(() {
        items = places;
        isLoading = false;
      });
    }).catchError((error) {
      print("Error fetching places: $error");
      setState(() => isLoading = false);
    });
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

  List<ListingItem> getFilteredItems() {
    if (selectedMoods.isEmpty) return items;
    return items.where((item) => item.moods.any((mood) => selectedMoods.contains(mood))).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchPlaces(widget.selectedMood);
  }

  @override
  Widget build(BuildContext context) {
    List<ListingItem> filteredItems = getFilteredItems();

    return Scaffold(
      body: Stack(
        children: [
          MapScreen(onPlaceSelected: onPlaceSelected, places: filteredItems),
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
                                Wrap(
                                  spacing: 8.0,
                                  children: [
                                    for (String mood in ['Relax', 'Music', 'Social', 'Sport'])
                                      FilterChip(
                                        label: Text(mood),
                                        selected: selectedMoods.contains(mood),
                                        onSelected: (selected) {
                                          setState(() {
                                            selected
                                                ? selectedMoods.add(mood)
                                                : selectedMoods.remove(mood);
                                            fetchPlaces();
                                          });
                                        },
                                      ),
                                  ],
                                ),
                                Expanded(
                                  child: isLoading
                                      ? Center(child: CircularProgressIndicator())
                                      : (filteredItems.isEmpty
                                          ? Center(child: Text("No places found"))
                                          : ListView.builder(
                                              controller: scrollController,
                                              itemCount: filteredItems.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                  child: ListingBox(item: filteredItems[index]),
                                                );
                                              },
                                            )),
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
    );
  }
}