class Transporteur {
  final int? id;
  final int userId;
  final String email;
  final String username;
  final String password;
  final String phone;
  final int? points;
  final String? imageUrl;
  final int? serviceId;
  final bool? disponibilite;
  final double? noteMoyenne;
  final String? gender;
  final String? vehiculeType;

  Transporteur({
    this.id,
    required this.userId,
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
    this.points,
    this.imageUrl,
    this.serviceId,
    this.disponibilite,
    this.noteMoyenne,
    this.gender,
    this.vehiculeType,
  });

  factory Transporteur.fromJson(Map<String, dynamic> json) {
    return Transporteur(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      points: json['points'],
      imageUrl: json['image_url'],
      serviceId: json['service_id'],
      disponibilite: json['disponibilite'] == 1,
      noteMoyenne: double.parse(json['note_moyenne'].toString()),
      gender: json['gender'],
      vehiculeType: json['vehicule_type'],
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
      'service_id': serviceId,
      'disponibilite': disponibilite,
      'note_moyenne': noteMoyenne,
      'gender': gender,
      'vehicule_type': vehiculeType,
    };
  }
}
