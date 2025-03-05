import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/core/utils.dart';
import 'package:moodmap/models/activity_model.dart';
import 'package:moodmap/core/services/auth_service.dart';
import 'package:moodmap/core/services/visited_place_service.dart'; // Make sure you have this service
import 'package:shared_preferences/shared_preferences.dart'; // For accessing user preferences

class ListingBox extends StatelessWidget {
  final dynamic item;
  final bool showReviewButton; // Flag to show Review button
  final VoidCallback? onReviewPressed; // Callback when review button is pressed
  final AuthService authService = AuthService();

  ListingBox({required this.item, this.showReviewButton = false, this.onReviewPressed});

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id"); // Retrieve userId from shared preferences
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: Icon(Icons.image, color: Colors.grey[600]),
    );
  }

  // Function to handle the "Go" button action
  void _handleGoButton(BuildContext context, String? userId) async {
    final visitedPlaceService = VisitedPlaceService();

    if (userId != null) {
      // Add place to visited places
      bool success = await visitedPlaceService.addVisitedPlace(item.id);

      if (success) {
        // Notify user of success
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Place added to your visited places!")));
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add place.")));
      }
    }
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
                        // Image on the left with rounded corners
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
                      item is Activity ? getEmojiActivities(item.category) : getEmojiPlaces(item.category),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            // "Go" or "Review" button on the right
            GestureDetector(
              onTap: () async {
                // Fetch the userId asynchronously before calling the handler
                String? userId = await _getUserId();
                if (showReviewButton && onReviewPressed != null) {
                  onReviewPressed!(); // Execute review callback
                } else {
                  _handleGoButton(context, userId); // Execute Go button action
                }
              },
              child: Container(
                width: 42, // Fixed width for the button
                decoration: BoxDecoration(
                  color: AppTheme.blue,
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
                        showReviewButton ? Icons.rate_review : (item is Activity ? Icons.play_arrow : Icons.directions_walk),
                        size: 20,
                        color: Colors.black,
                      ),
                      Text(
                        showReviewButton ? 'Review' : 'Go',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
