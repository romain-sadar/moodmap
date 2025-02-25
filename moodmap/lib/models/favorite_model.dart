import 'package:moodmap/models/activity_model.dart';
import 'package:moodmap/models/place_model.dart';

class FavoriteData {
  final String mood;
  final List<ListingItem> places;
  final List<Activity> activities;

  FavoriteData({required this.mood, required this.places, required this.activities});

  factory FavoriteData.fromJson(Map<String, dynamic> json) {
    return FavoriteData(
      mood: json['mood'],
      places: (json['places'] as List).map((place) => ListingItem.fromJson(place)).toList(),
      activities: (json['activities'] as List).map((activity) => Activity.fromJson(activity)).toList(),
    );
  }
}