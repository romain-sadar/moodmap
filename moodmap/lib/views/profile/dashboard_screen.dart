import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/widgets/listing_box.dart';
import 'package:moodmap/core/services/visited_place_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodmap/core/constants.dart';
import 'package:moodmap/views/home/widgets/mood_form_location.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOnWeek = true;
  List<ListingItem> visitedPlaces = []; // To hold the list of visited places
  bool isLoading = true; // To handle the loading state
  final VisitedPlaceService visitedPlaceService = VisitedPlaceService(); // Service instance

  @override
  void initState() {
    super.initState();
    _getVisitedPlaces(); // Call method to fetch visited places
  }

  // Fetch visited places from the service
  Future<void> _getVisitedPlaces() async {
    try {
      final authData = await _getAuthData();
      final token = authData['token'];

      if (token == null) {
        throw Exception('No token found');
      }

      // Use the service to fetch visited places
      final places = await visitedPlaceService.getVisitedPlaces();

      setState(() {
        visitedPlaces = places;
        isLoading = false; // Stop loading after data is fetched
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading even in case of an error
      });
    }
  }

  Future<Map<String, dynamic>> _getAuthData() async {
    // Retrieve the token and user ID from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userId = prefs.getString('user_id');

    return {'token': token, 'userId': userId};
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report buttons section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text("My report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOnWeek ? AppTheme.blue : Colors.grey,
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
                            isOnWeek = true;
                          });
                        },
                        child: Text("Week"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !isOnWeek ? AppTheme.violet : Colors.grey,
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
                            isOnWeek = false;
                          });
                        },
                        child: Text("Month"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Report statistics section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.pin),
                      SizedBox(width: 10),
                      Expanded(child: Text("This week, you visited X places!")),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.mood),
                      SizedBox(width: 10),
                      Expanded(child: Text("Your average mood was Focus")),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.hourglass_bottom),
                      SizedBox(width: 10),
                      Expanded(child: Text("You spent Y hours taking care of your mind")),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.nature),
                      SizedBox(width: 10),
                      Expanded(child: Text("Your favorite place to visit is: Parc")),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // History section (Visited Places)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            // Display loading indicator while fetching data
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shrinkWrap: true,
                  itemCount: visitedPlaces.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the MoodFormLocationScreen when a ListingBox is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodFormLocationScreen(
                              visitedPlaceId: visitedPlaces[index].id, // Pass the ID or other necessary data
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ListingBox(item: visitedPlaces[index]),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
