import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/activity_model.dart';
import 'package:moodmap/models/favorite_model.dart';
import 'package:moodmap/models/place_model.dart';
import 'dart:convert';

import 'package:moodmap/views/home/widgets/listing_box.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isOnMap = true;
  List<FavoriteData> favoriteList = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteData();
  }

void _loadFavoriteData() {
  String jsonData = '''
  [
    {
      "mood": "Happy",
      "places": [
        {
          "id": "1",
          "label": "Will",
          "latitude": -58.7093475,
          "longitude": 132.387897,
          "description": "Cozy bruncher.",
          "category": "exist-specific",
          "photo": "https://picsum.photos/462/600",
          "moods": ["Happy", "Relax"]
        },
        {
          "id": "2",
          "label": "Couple Spot",
          "latitude": 3.1999785,
          "longitude": -132.495354,
          "description": "Romantic atmosphere.",
          "category": "see-radio-rule",
          "photo": "https://picsum.photos/462/645",
          "moods": ["Happy", "Excited"]
        }
      ],
      "activities": []
    },
    {
      "mood": "Focus",
      "places": [
        {
          "id": "3",
          "label": "Quiet Café",
          "latitude": -12.4567,
          "longitude": 45.6789,
          "description": "Perfect for working.",
          "category": "work-friendly",
          "photo": "https://picsum.photos/300/200",
          "moods": ["Focus"]
        }
      ],
      "activities": []
    }
  ]
  ''';

    List<dynamic> data = jsonDecode(jsonData);
    setState(() {
      favoriteList = data.map((item) => FavoriteData.fromJson(item)).toList();
    });
  }

  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOnMap ? AppTheme.blue : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
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
                  child: const Icon(Icons.map, color: Colors.white),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isOnMap ? AppTheme.violet : Colors.grey,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
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
                  child: const Icon(Icons.location_off, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  final moodItem = favoriteList[index];
                  List<dynamic> itemsToDisplay = isOnMap
                      ? moodItem.places
                      : moodItem.activities;

                  return _buildExpansionTile(
                    moodItem.mood,
                    itemsToDisplay.map((item) {
                      if (item is ListingItem) {
                        // Si c'est un ListingItem
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListingBox(item: item),
                        );
                      } else if (item is Activity) {
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListingBox(item: item,),  // Vous devez créer un widget ActivityBox
                        );
                      } else {
                        return Container(); // Retourner un widget vide si le type est inconnu
                      }
                    }).toList(),
                    _getMoodColor(moodItem.mood),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildExpansionTile(String title, List<Widget> children, Color circleColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            title: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: circleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Happy":
        return Colors.yellow;
      case "Focus":
        return Colors.deepPurple;
      case "Social":
        return Colors.green;
      case "Relax":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
