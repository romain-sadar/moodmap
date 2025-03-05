import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

@freezed
class ListingItem with _$ListingItem {
  const factory ListingItem({
    required String id,
    required String label,
    required double latitude,
    required double longitude,
    required String description,
    required String category,
    String? photo,
    required List<String> moods,
    String? createdAt,
    String? updatedAt,
  }) = _ListingItem;

  factory ListingItem.fromJson(Map<String, dynamic> json) {
  return ListingItem(
    id: json['id'] as String,  // Ensure 'id' field exists
    label: json['label'] as String,
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    description: json['description'] as String,
    category: json['category'] as String,
    photo: json['photo'] as String?,  // Handle null values gracefully
    moods: List<String>.from(json['moods'] ?? []),
    createdAt: json['created_at'] as String?,  // Use snake_case based on API response
    updatedAt: json['updated_at'] as String?,  // Use snake_case based on API response
  );
}

}
