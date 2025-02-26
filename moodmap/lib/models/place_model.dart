import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

@freezed
class ListingItem with _$ListingItem {
  const factory ListingItem({
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

  factory ListingItem.fromJson(Map<String, dynamic> json) => _$ListingItemFromJson(json);
}
