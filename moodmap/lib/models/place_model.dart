class ListingItem {
  final String imagePath;
  final String title;
  final String distance;
  final String description;
  final List<String> tags;
  final String type; 

  ListingItem({
    required this.imagePath,
    required this.title,
    required this.distance,
    required this.description,
    required this.tags,
    required this.type,
  });
}