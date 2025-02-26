import 'package:moodmap/core/services/place_service.dart';
import 'package:moodmap/models/place_model.dart';

class PlaceRepository {
  final PlaceService placeService;

  PlaceRepository({required this.placeService});

  Future<List<ListingItem>> getPlaces() async {
    return await placeService.fetchPlaces();
  }

  Future<ListingItem> getPlaceById(String id) async {
    return await placeService.fetchPlaceById(id);
  }

  Future<ListingItem> getPlaceByMood(String mood) async {
    return await placeService.fetchPlaceByMood(mood);
  }
}
