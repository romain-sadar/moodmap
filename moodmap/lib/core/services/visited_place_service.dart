import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moodmap/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/models/place_model.dart';

class VisitedPlaceService {
  final String baseUrl = AppConstants.apiBaseUrl;

  // Method to get the token and userId from SharedPreferences
  Future<Map<String, String?>> _getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userId = prefs.getString('user_id');
    
    return {
      'token': token,
      'userId': userId,
    };
  }

  // Fetch visited places
  Future<List<ListingItem>> getVisitedPlaces() async {
    try {
      final authData = await _getAuthData();
      final token = authData['token'];
      
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/visited-place/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> visitedPlacesData = data['results'];

        // Fetch detailed information for each visited place
        List<ListingItem> places = [];
        for (var visitedPlace in visitedPlacesData) {
          String placeId = visitedPlace['place'];
          final placeResponse = await http.get(
            Uri.parse('$baseUrl/place/$placeId/'),  // Assuming you have a place endpoint
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (placeResponse.statusCode == 200) {
            Map<String, dynamic> placeData = json.decode(placeResponse.body);
            // Map the fetched place data to ListingItem
            places.add(ListingItem.fromJson(placeData));
          } else {
            throw Exception('Failed to load place details for ID: $placeId');
          }
        }

        return places;
      } else {
        throw Exception('Failed to load visited places. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching visited places: $e');
    }
  }

  Future<int> getMoodIdByName(String moodName) async {
    final url = Uri.parse('$baseUrl/mood/get-id-by-name/?label=$moodName');
    
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['id']; // Assuming 'id' is returned
    } else if (response.statusCode == 404) {
      throw Exception('Mood not found');
    } else {
      throw Exception('Failed to fetch Mood ID');
    }
  }

  // Update feedback for a visited place using a PATCH request
  Future<void> updateVisitedPlaceFeedback(
      String placeId, String moodName,) async {
    final moodId = await getMoodIdByName(moodName);  // Get the Mood ID by name
    final url = Uri.parse('$baseUrl/visited-place/$placeId/');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'mood_feedback': moodId,
      }),
    );

    if (response.statusCode == 200) {
      print('Visited place feedback updated successfully!');
    } else {
      throw Exception('Failed to update feedback');
    }
  }

  // Add a visited place
  Future<bool> addVisitedPlace(String placeId) async {
    try {
      final authData = await _getAuthData();
      final userId = authData['userId'];
      final token = authData['token'];  // Use _getAuthData() to get token

      // Ensure that userId and token are not null
      if (userId == null || token == null) {
        throw Exception('No user ID or token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/visited-place/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'user': userId,
          'place': placeId,
          'visited_time': DateTime.now().toIso8601String(),
          // Add other necessary data, like mood_feedback
        }),
      );

      if (response.statusCode == 201) {
        return true; // Successfully created
      } else {
        return false; // Failed to create
      }
    } catch (e) {
      return false; // Network or other error
    }
  }
}
