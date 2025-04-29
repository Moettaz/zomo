import 'dart:convert';

class NotificationModel {
  final String title;
  final String description;
  final String image;

  NotificationModel({
    required this.title,
    required this.description,
    required this.image,
  });

  // Convert Map to NotificationModel
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }

  // Convert NotificationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }

  // From JSON
  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // To JSON
  String toJson() => json.encode(toMap());
}
