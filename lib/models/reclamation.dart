class Reclamation {
  final int? id;
  final int clientId;
  final int transporteurId;
  final int serviceId;
  final DateTime dateCreation;
  final String sujet;
  final String description;
  final String status;
  final String priorite;

  Reclamation({
    this.id,
    required this.clientId,
    required this.transporteurId,
    required this.serviceId,
    required this.dateCreation,
    required this.sujet,
    required this.description,
    required this.status,
    required this.priorite,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: json['id'],
      clientId: json['client_id'],
      transporteurId: json['transporteur_id'],
      serviceId: json['service_id'],
      dateCreation: DateTime.parse(json['date_creation']),
      sujet: json['sujet'],
      description: json['description'],
      status: json['status'],
      priorite: json['priorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'transporteur_id': transporteurId,
      'service_id': serviceId,
      'date_creation': dateCreation.toIso8601String(),
      'sujet': sujet,
      'description': description,
      'status': status,
      'priorite': priorite,
    };
  }

  Reclamation copyWith({
    int? id,
    int? clientId,
    int? transporteurId,
    int? serviceId,
    DateTime? dateCreation,
    String? sujet,
    String? description,
    String? status,
    String? priorite,
  }) {
    return Reclamation(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      transporteurId: transporteurId ?? this.transporteurId,
      serviceId: serviceId ?? this.serviceId,
      dateCreation: dateCreation ?? this.dateCreation,
      sujet: sujet ?? this.sujet,
      description: description ?? this.description,
      status: status ?? this.status,
      priorite: priorite ?? this.priorite,
    );
  }
}
