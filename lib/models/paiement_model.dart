import 'package:zomo/models/client.dart';
import 'package:zomo/models/service_model.dart';

class Payment {
  final int? id;
  final int clientId;
  final int transporteurId;
  final int serviceId;
  final double montant;
  final String methodePaiement;
  final DateTime datePaiement;
  final String status;
  final String reference;
  final Client client;
  final Service service;

  Payment({
    this.id,
    required this.clientId,
    required this.transporteurId,
    required this.serviceId,
    required this.montant,
    required this.methodePaiement,
    required this.datePaiement,
    required this.status,
    required this.reference,
    required this.client,
    required this.service,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      clientId: json['client_id'],
      transporteurId: json['transporteur_id'],
      serviceId: json['service_id'],
      montant: double.parse(json['montant'].toString()),
      methodePaiement: json['methode_paiement'],
      datePaiement: DateTime.parse(json['date_paiement']),
      status: json['status'],
      reference: json['reference'],
      client: Client.fromJson(json['client']),
      service: Service.fromJson(json['service']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'transporteur_id': transporteurId,
      'service_id': serviceId,
      'montant': montant,
      'methode_paiement': methodePaiement,
      'date_paiement': datePaiement.toIso8601String(),
      'status': status,
      'reference': reference,
      'client': client.toJson(),
      'service': service.toJson(),
    };
  }
}
