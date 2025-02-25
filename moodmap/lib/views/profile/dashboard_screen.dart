import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';
import 'package:moodmap/models/place_model.dart';
import 'package:moodmap/views/home/widgets/listing_box.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOnWeek = true;
  ListingItem item1 = ListingItem(
    photo: 'assets/images/brunchesCafe.jpg',
    label: 'Brunch Café',
    longitude: 0,
    latitude: 0,
    description: 'Cozy bruncher.',
    moods: ['Calm', 'Relax'],
    category: '☕️',
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Row(
                      children: [
                        Text("My report", style: TextStyle(fontSize: 16)),
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
                    SizedBox(height: 10),

                    
                    Row(children: [Icon(Icons.pin), SizedBox(width: 10), Expanded(child: Text("This week, you visited 3 places! (1 more than last week)"))]),
                    SizedBox(height: 5),
                    Row(children: [Icon(Icons.mood), SizedBox(width: 10), Expanded(child: Text("Your average mood was Focus"))]),
                    SizedBox(height: 5),
                    Row(children: [Icon(Icons.hourglass_bottom), SizedBox(width: 10), Expanded(child: Text("You spent 5 hours taking care of your mind"))]),
                    SizedBox(height: 5),
                    Row(children: [Icon(Icons.nature), SizedBox(width: 10), Expanded(child: Text("Your favorite place to visit is: Parc"))]),

                    SizedBox(height: 20),

                    
                    Text("History", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),

                   
                    ListView.builder(
                      shrinkWrap: true, 
                      physics: NeverScrollableScrollPhysics(), 
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListingBox(item: item1),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
