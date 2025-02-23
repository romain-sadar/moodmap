import 'package:flutter/material.dart';
import 'package:moodmap/core/themes.dart';

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
class MoodFormScreen extends StatefulWidget {
   final VoidCallback goToHome; // Fonction à appeler pour revenir à l'écran d'accueil

  // Constructor
  MoodFormScreen({required this.goToHome});

  @override
  _MoodFormScreenState createState() => _MoodFormScreenState();
}

class _MoodFormScreenState extends State<MoodFormScreen> {
  Mood _moodValue = Mood.happy; // Valeur initiale du slider
  List<String> selectedTags = [];
  bool wantsToMove = false; // Pour la section "Do you want to move?"

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
             widget.goToHome();
            },
            child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
        backgroundColor: AppTheme.blue,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fond bleu avec le slider et texte
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: AppTheme.blue,
            child: Column(
              children: [
                Text("How do you feel?", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(_moodValue.emoji, style: TextStyle(fontSize: 90)),
               
                Text(_moodValue.label, style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 20.0, // Épaisseur du track
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.0), // Taille du curseur
                    activeTrackColor: Colors.white, // Couleur du track
                    inactiveTrackColor: Colors.white54, // Couleur du track quand il n'est pas actif
                    thumbColor: Colors.white, // Couleur du curseur
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
             // Bloc blanc avec "Describe your feelings"
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
                    Text("Describe your feelings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height:5),
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
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                            shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                            
                    SizedBox(height: 10),
                            
                    
                    Text("Do you want to move somewhere?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height:5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: wantsToMove ? AppTheme.blue : Colors.white,
                            foregroundColor: wantsToMove ? Colors.white : Colors.black,
                            shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
                            
                          ),
                          onPressed: () => setState(() => wantsToMove = true),
                          child: Text("Yes"),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: !wantsToMove ? AppTheme.blue : Colors.white,
                            foregroundColor: !wantsToMove ? Colors.white : Colors.black,
                            shape: StadiumBorder(side: BorderSide(color: AppTheme.blue)),
                          ),
                          onPressed: () => setState(() => wantsToMove = false),
                          child: Text("No"),
                        ),
                      ],
                    ),
                            
                  
                    Spacer(),
                   
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Mood: ${_moodValue.label}");
                          print("Selected Tags: $selectedTags");
                          print("Wants to Move: $wantsToMove");
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
    path.moveTo(0, size.height); // Commencer en bas à gauche
    path.quadraticBezierTo(
      size.width / 2, -size.height / 2, size.width, size.height); // Inverser la courbure
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