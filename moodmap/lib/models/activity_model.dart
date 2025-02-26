class Activity {
  final String label;
  final double time;
  final String description;
  final String category;
  String? photo;
  final List<String> moods;

  Activity({
    required this.label,
    required this.time,
    required this.description,
    required this.category,
    this.photo,
    required this.moods,
  });
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      label: json['label'],
      time: json['time'],
      description: json['description'],
      category: json['category'],
      photo: json['photo'],
      moods: List<String>.from(json['moods']),
    );
  }
}
