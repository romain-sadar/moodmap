import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/core/constants.dart';

class PlaceService {
  final String baseUrl = AppConstants.apiBaseUrl;

  Future<List<ListingItem>> fetchPlaces() async {
  final response = await http.get(Uri.parse('$baseUrl/place/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> placesData = data['results'];

    return placesData.map((json) => ListingItem.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load places');
  }
}


  Future<ListingItem> fetchPlaceById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/place/$id'));

    if (response.statusCode == 200) {
      return ListingItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load place');
    }
  }

  Future<ListingItem> fetchPlaceByMood(String mood) async {
    final response = await http.get(Uri.parse('$baseUrl/place/?moods[]=$mood'));

    if (response.statusCode == 200) {
      return ListingItem.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load place');
    }
  }
}
