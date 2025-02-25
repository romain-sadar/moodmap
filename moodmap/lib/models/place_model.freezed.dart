// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListingItem _$ListingItemFromJson(Map<String, dynamic> json) {
  return _ListingItem.fromJson(json);
}

/// @nodoc
mixin _$ListingItem {
  String get label => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get photo => throw _privateConstructorUsedError;
  List<String> get moods => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ListingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListingItemCopyWith<ListingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListingItemCopyWith<$Res> {
  factory $ListingItemCopyWith(
          ListingItem value, $Res Function(ListingItem) then) =
      _$ListingItemCopyWithImpl<$Res, ListingItem>;
  @useResult
  $Res call(
      {String label,
      double latitude,
      double longitude,
      String description,
      String category,
      String? photo,
      List<String> moods,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class _$ListingItemCopyWithImpl<$Res, $Val extends ListingItem>
    implements $ListingItemCopyWith<$Res> {
  _$ListingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? category = null,
    Object? photo = freezed,
    Object? moods = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      photo: freezed == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      moods: null == moods
          ? _value.moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListingItemImplCopyWith<$Res>
    implements $ListingItemCopyWith<$Res> {
  factory _$$ListingItemImplCopyWith(
          _$ListingItemImpl value, $Res Function(_$ListingItemImpl) then) =
      __$$ListingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String label,
      double latitude,
      double longitude,
      String description,
      String category,
      String? photo,
      List<String> moods,
      String? createdAt,
      String? updatedAt});
}

/// @nodoc
class __$$ListingItemImplCopyWithImpl<$Res>
    extends _$ListingItemCopyWithImpl<$Res, _$ListingItemImpl>
    implements _$$ListingItemImplCopyWith<$Res> {
  __$$ListingItemImplCopyWithImpl(
      _$ListingItemImpl _value, $Res Function(_$ListingItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? description = null,
    Object? category = null,
    Object? photo = freezed,
    Object? moods = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ListingItemImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      photo: freezed == photo
          ? _value.photo
          : photo // ignore: cast_nullable_to_non_nullable
              as String?,
      moods: null == moods
          ? _value._moods
          : moods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListingItemImpl implements _ListingItem {
  const _$ListingItemImpl(
      {required this.label,
      required this.latitude,
      required this.longitude,
      required this.description,
      required this.category,
      this.photo,
      required final List<String> moods,
      this.createdAt,
      this.updatedAt})
      : _moods = moods;

  factory _$ListingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListingItemImplFromJson(json);

  @override
  final String label;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String description;
  @override
  final String category;
  @override
  final String? photo;
  final List<String> _moods;
  @override
  List<String> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  @override
  String toString() {
    return 'ListingItem(label: $label, latitude: $latitude, longitude: $longitude, description: $description, category: $category, photo: $photo, moods: $moods, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListingItemImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.photo, photo) || other.photo == photo) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      label,
      latitude,
      longitude,
      description,
      category,
      photo,
      const DeepCollectionEquality().hash(_moods),
      createdAt,
      updatedAt);

  /// Create a copy of ListingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListingItemImplCopyWith<_$ListingItemImpl> get copyWith =>
      __$$ListingItemImplCopyWithImpl<_$ListingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListingItemImplToJson(
      this,
    );
  }
}

abstract class _ListingItem implements ListingItem {
  const factory _ListingItem(
      {required final String label,
      required final double latitude,
      required final double longitude,
      required final String description,
      required final String category,
      final String? photo,
      required final List<String> moods,
      final String? createdAt,
      final String? updatedAt}) = _$ListingItemImpl;

  factory _ListingItem.fromJson(Map<String, dynamic> json) =
      _$ListingItemImpl.fromJson;

  @override
  String get label;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get description;
  @override
  String get category;
  @override
  String? get photo;
  @override
  List<String> get moods;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;

  /// Create a copy of ListingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListingItemImplCopyWith<_$ListingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
