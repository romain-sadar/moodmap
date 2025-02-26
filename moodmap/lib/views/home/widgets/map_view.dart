import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:moodmap/core/utils.dart';
import 'package:moodmap/models/place_model.dart';

class MapScreen extends StatefulWidget {
  final Function(ListingItem) onPlaceSelected;
  final List<ListingItem> places;

  const MapScreen({
    Key? key,
    required this.onPlaceSelected,
    required this.places,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.places.isEmpty
          ? Center(child: CircularProgressIndicator()) // ✅ Handle loading state
          : FlutterMap(
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
                  markers: widget.places.map((place) {
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
        child: Text(
          getEmojiPlaces(place.category ?? ""),
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
