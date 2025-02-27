class User {
  final String id;
  final String username;
  final String email;
  final bool isPremium;
  final String gender;
  final int age;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isPremium,
    required this.gender,
    required this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isPremium: json['isPremium'] ?? false,
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isPremium': isPremium,
      'gender': gender,
      'age': age,
    };
  }
}