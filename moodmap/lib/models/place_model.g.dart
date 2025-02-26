// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListingItemImpl _$$ListingItemImplFromJson(Map<String, dynamic> json) =>
    _$ListingItemImpl(
      label: json['label'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      photo: json['photo'] as String?,
      moods: (json['moods'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$ListingItemImplToJson(_$ListingItemImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'category': instance.category,
      'photo': instance.photo,
      'moods': instance.moods,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
