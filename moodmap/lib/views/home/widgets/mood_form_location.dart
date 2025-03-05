import 'package:flutter/material.dart';
import 'package:moodmap/core/services/visited_place_service.dart';  // Import your service file
import 'package:duration_picker/duration_picker.dart';
import 'package:moodmap/core/themes.dart';


enum Mood {
  angry("😡", "Angry"),
  calm("😌", "Calm"),
  excited("🤩", "Excited"),
  happy("🙂", "Happy"),
  stressed("😖", "Stressed"),
  tired("🥱", "Tired");

  final String emoji;
  final String label;

  const Mood(this.emoji, this.label);

  List<String> get tags {
    switch (this) {
      case Mood.angry:
        return ["Frustrated", "Irritated", "Annoyed", "Furious"];
      case Mood.calm:
        return ["Relaxed", "Peaceful", "Content", "Serene"];
      case Mood.excited:
        return ["Energetic", "Eager", "Enthusiastic", "Elated"];
      case Mood.happy:
        return ["Joyful", "Optimistic", "Cheerful", "Grateful"];
      case Mood.stressed:
        return ["Overwhelmed", "Anxious", "Tense", "Burned out"];
      case Mood.tired:
        return ["Exhausted", "Sleepy", "Drained", "Fatigued"];
    }
  }
}

class MoodFormLocationScreen extends StatefulWidget {
  final String visitedPlaceId;

  MoodFormLocationScreen({Key? key, required this.visitedPlaceId}) : super(key: key);

  @override
  _MoodFormLocationScreenState createState() => _MoodFormLocationScreenState();
}


class _MoodFormLocationScreenState extends State<MoodFormLocationScreen> {
  Mood _moodValue = Mood.happy;
  List<String> selectedTags = [];
  Duration _selectedDuration = Duration(hours: 0, minutes: 0);
  bool favorites = false;

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

     Future<void> _pickDuration() async {
    Duration? picked = await showDurationPicker(
      context: context,
      initialTime: _selectedDuration,
      baseUnit: BaseUnit.minute,
    
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
      
    );

    if (picked != null) {
      setState(() {
        _selectedDuration = picked;
      });
    }
  }


  void _showFavoriteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add to Favorites?"),
        backgroundColor: Colors.grey[200],
        content: Text("Do you want to add this place to your favorites?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                favorites = false;
              });
              print("Favorite set to: $favorites");
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey, 
            ),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                favorites = true;
              });
              
              print("Favorite set to: $favorites");
              Navigator.of(context).pop(); 
            },
             style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blue, 
              foregroundColor: Colors.white, 
            ),
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

  // Initialize the visited place service
  final visitedPlaceService = VisitedPlaceService();

  Future<void> _updateVisitedPlace() async {
    final String placeId = 'visitedPlaceId123';  // Replace with the actual place ID
    final String moodName = _moodValue.label;  // Use the label of the selected mood

    try {
      await visitedPlaceService.updateVisitedPlaceFeedback(placeId, moodName);
      print('Visited place feedback updated successfully!');
      // Optionally, show a success message to the user
    } catch (error) {
      print('Failed to update visited place: $error');
      // Handle error (e.g., show an error message to the user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // Skip action, navigate away
            },
            child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
        backgroundColor: AppTheme.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: AppTheme.blue,
            child: Column(
              children: [
                Text("How did you feel at this place?", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(_moodValue.emoji, style: TextStyle(fontSize: 90)),
                Text(_moodValue.label, style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 20.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.0),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white54,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: Mood.values.indexOf(_moodValue).toDouble(),
                    min: 0,
                    max: Mood.values.length - 1,
                    divisions: Mood.values.length - 1,
                    onChanged: (value) {
                      setState(() {
                        _moodValue = Mood.values[value.toInt()];
                        selectedTags.clear();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 255,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Describe how you felt at this place.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 10,
                      children: _moodValue.tags.map((tag) {
                        bool isSelected = selectedTags.contains(tag);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ChoiceChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (selected) => toggleTag(tag),
                            selectedColor: AppTheme.blue,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : AppTheme.blue),
                            shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text("How long did you stay here?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Center(
                      child: ElevatedButton(
                        onPressed: _pickDuration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blue,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        child: Text(
                          " ${_selectedDuration.inHours}h ${_selectedDuration.inMinutes % 60}m",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showFavoriteDialog(context);
                          print("Mood: ${_moodValue.label}");
                          print("Selected Tags: $selectedTags");
                          print("Time: $_selectedDuration");
                          print("Favorite: $favorites");

                          _updateVisitedPlace();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blue,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text("Let's go →", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 255,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: OvalClipper(),
              child: Container(
                height: 55,
                color: AppTheme.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2, -size.height / 2, size.width, size.height); 
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}