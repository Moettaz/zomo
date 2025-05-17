import 'package:zomo/models/client.dart';
import 'package:zomo/models/transporteur.dart';

class TrajetModel {
  final int id;
  final int clientId;
  final int transporteurId;
  final int serviceId;
  final DateTime departureDateTime;
  final DateTime arrivalDateTime;
  final String startPoint;
  final String endPoint;
  final double price;
  final String? note;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Transporteur? transporteur;
  final Client? client;
  TrajetModel({
    required this.id,
    required this.clientId,
    required this.transporteurId,
    required this.serviceId,
    required this.departureDateTime,
    required this.arrivalDateTime,
    required this.startPoint,
    required this.endPoint,
    required this.price,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.transporteur,
    this.client,
  });

  // Convert Map to HistoryModel
  factory TrajetModel.fromJson(Map<String, dynamic> json) {
    return TrajetModel(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      transporteurId: json['transporteur_id'] as int,
      serviceId: json['service_id'] as int,
      departureDateTime: DateTime.parse(json['date_heure_depart']),
      arrivalDateTime: DateTime.parse(json['date_heure_arrivee']),
      startPoint: json['point_depart'] as String,
      endPoint: json['point_arrivee'] as String,
      price: double.parse(json['prix'].toString()),
      note: json['note'] as String?,
      status: json['etat'] as String,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      transporteur: json['transporteur'] != null
          ? Transporteur.fromJson(json['transporteur'])
          : null,
      client: json['client'] != null
          ? Client.fromJson(json['client'])
          : null,
    );
  }

  // Convert HistoryModel to Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'transporteur_id': transporteurId,
      'service_id': serviceId,
      'date_heure_depart': departureDateTime.toIso8601String(),
      'date_heure_arrivee': arrivalDateTime.toIso8601String(),
      'point_depart': startPoint,
      'point_arrivee': endPoint,
      'prix': price,
      'note': note,
      'etat': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'transporteur': transporteur?.toJson(),
      'client': client?.toJson(),
    };
  }
}
