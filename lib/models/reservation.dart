import 'package:zomo/models/client.dart';
import 'package:zomo/models/product.dart';
import 'package:zomo/models/transporteur.dart';

class Reservation {
  final int? id;
  final int clientId;
  final int transporteurId;
  final int serviceId;
  final String dateReservation;
  final String status;
  final String? commentaire;
  final String? colisSize;
  final String? typeMenagement;
  final String? typeVehicule;
  final String? distance;
  final String from;
  final String to;
  final String? heureReservation;
  final int? etage;
  final List<Product>? products;
  final Client? client;
  final Transporteur? transporteur;

  Reservation({
    this.id,
    required this.clientId,
    required this.transporteurId,
    required this.serviceId,
    required this.dateReservation,
    required this.status,
    this.commentaire,
    this.colisSize,
    this.typeMenagement,
    this.typeVehicule,
    this.distance,
    required this.from,
    required this.to,
    this.heureReservation,
    this.etage,
    this.products,
    this.client,
    this.transporteur,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      clientId: json['client_id'],
      transporteurId: json['transporteur_id'],
      serviceId: json['service_id'],
      dateReservation: json['date_reservation'],
      status: json['status'],
      commentaire: json['commentaire'],
      colisSize: json['colis_size'],
      typeMenagement: json['type_menagement'],
      typeVehicule: json['type_vehicule'],
      distance: json['distance'],
      from: json['from'],
      to: json['to'],
      heureReservation: json['heure_reservation'],
      etage: json['etage'],
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => Product.fromJson(product))
              .toList() ??
          [],
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      transporteur: json['transporteur'] != null
          ? Transporteur.fromJson(json['transporteur'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'client_id': clientId,
      'transporteur_id': transporteurId,
      'service_id': serviceId,
      'date_reservation': dateReservation,
      'status': status,
      if (commentaire != null) 'commentaire': commentaire,
      'colis_size': colisSize,
      'type_menagement': typeMenagement,
      'type_vehicule': typeVehicule,
      'distance': distance,
      'from': from,
      'to': to,
      'heure_reservation': heureReservation,
      'etage': etage,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}
