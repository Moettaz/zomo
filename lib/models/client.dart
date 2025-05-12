class Client {
  final int? id;
  final int userId;
  final String email;
  final String username;
  final String password;
  final String phone;
  final int? points;
  final String? imageUrl;

  Client({
    this.id,
    required this.userId,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    this.points,
    this.imageUrl,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      points: json['points'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'username': username,
      'password': password,
      'phone': phone,
      'points': points,
      'image_url': imageUrl,
    };
  }
} 