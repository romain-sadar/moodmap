class ListingItem {
  final String label;
  final double latitude;
  final double longitude;
  final String description;
  final String category;
  final String photo;
  final List<String> moods;

  ListingItem({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.category,
    required this.photo,
    required this.moods,
  });

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    return ListingItem(
      label: json['label'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
      category: json['category'],
      photo: json['photo'],
      moods: List<String>.from(json['moods']),
    );
  }

 
}
