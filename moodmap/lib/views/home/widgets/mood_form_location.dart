import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';

enum Mood {
  verySad("😢", "Very Sad"),
  sad("😞", "Sad"),
  neutral("😐", "Neutral"),
  happy("🙂", "Happy"),
  veryHappy("😄", "Very Happy");

  final String emoji;
  final String label;

  const Mood(this.emoji, this.label);
   List<String> get tags {
    switch (this) {
      case Mood.verySad:
        return ["Stressed", "Depressed", "Hopeless", "Exhausted"];
      case Mood.sad:
        return ["Anxious", "Worried", "Disappointed", "Frustrated"];
      case Mood.neutral:
        return ["Indifferent", "Bored", "Relaxed", "Chill"];
      case Mood.happy:
        return ["Excited", "Romantic", "Awesome", "Fantastic"];
      case Mood.veryHappy:
        return ["Euphoric", "Overjoyed", "Ecstatic", "Unstoppable"];
    }
  }
}
class MoodFormLocationScreen extends StatefulWidget {
  @override
  _MoodFormLocationScreenState createState() => _MoodFormLocationScreenState();
}

class _MoodFormLocationScreenState extends State<MoodFormLocationScreen> {
  Mood _moodValue = Mood.happy; 
  List<String> selectedTags = [];
  Duration _selectedDuration = Duration(hours: 0, minutes: 0);
  bool favorites=false;
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
              backgroundColor: Colors.blue, 
              foregroundColor: Colors.white, 
            ),
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              
            },
            child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.blue,
            child: Column(
              children: [
                Text("How did you feel at this place ?", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                    value:  Mood.values.indexOf(_moodValue).toDouble(),
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
            top: 275, 
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
                    SizedBox(height:10),
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
                            selectedColor: Colors.blue,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.blue),
                            shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                            
                    SizedBox(height: 20),
                            
                   Text("How long did you stay here?", style: TextStyle( fontSize: 18,fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Center(
                      child: ElevatedButton(
                        onPressed: _pickDuration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        child: Text(
                          " ${_selectedDuration.inHours}h ${_selectedDuration.inMinutes % 60}m",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ), Spacer(),
                            
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showFavoriteDialog(context);
                            print("Mood: ${_moodValue.label}");
                            print("Selected Tags: $selectedTags");
                            print("Time: $_selectedDuration");
                            print("Favorite: $favorites");

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text("Let's go →", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
          
          Positioned(
            top: 275,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: OvalClipper(),
              child: Container(
                height: 55,
                color: Colors.blue,
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