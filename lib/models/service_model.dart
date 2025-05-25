class Service {
  final int id;
  final String nom;
  final String description;
  final double prix;

  Service({
    required this.id,
    required this.nom,
    required this.description,
    required this.prix,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      prix: double.parse(json['prix'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
    };
  }
}
