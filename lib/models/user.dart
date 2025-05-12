class User {
  final int? id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final int roleId;
  final Role? role;

  User({
    this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.roleId,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      roleId: json['role_id'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role_id': roleId,
      'role': role?.toJson(),
    };
  }
}

class Role {
  final int? id;
  final String name;
  final String slug;

  Role({
    this.id,
    required this.name,
    required this.slug,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
} 