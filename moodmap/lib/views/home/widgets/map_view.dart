import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:moodmap/core/utils.dart';
import 'package:moodmap/models/place_model.dart';


class MapScreen extends StatefulWidget {
  final Function(ListingItem) onPlaceSelected; // Callback pour notifier HomeScreen

  const MapScreen({Key? key, required this.onPlaceSelected}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  


  final List<ListingItem> places = [
    ListingItem(
      label: "Starbucks",
      latitude: 1.2815295748825228,
      longitude: 103.8440929055369,
      description: "Café cosy à Singapour",
      category: "café",
      photo: "https://picsum.photos/300/200",
      moods: []
    ),
    ListingItem(
      label: "Restaurant La Belle",
      latitude: 1.2803057524299473,
      longitude: 103.84484969091453,
      description: "Un excellent restaurant français",
      category: "bar",
      photo: "https://picsum.photos/300/200",
      moods: []
    ),
    ListingItem(
      label: "Librairie XYZ",
      latitude: 1.2712578732354154,
      longitude: 103.81957713364619,
      description: "Une superbe librairie",
      category: "library",
      photo: "https://picsum.photos/300/200",
       moods: []
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(1.275, 103.835),
          zoom: 12.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
         
          MarkerLayer(
            markers: places.map((place) {
              return Marker(
                point: LatLng(place.latitude, place.longitude),
                width: 50,
                height: 50,
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      widget.onPlaceSelected(place);
                    },
                    child: getMarker(place),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  
  Widget getMarker(ListingItem place) {
    return Container(
      padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
      child: Center(
        child: 
          Text(
            getEmojiPlaces(place.category), 
            style: TextStyle(fontSize: 25),
          ),
      ),
    );
  }
}
