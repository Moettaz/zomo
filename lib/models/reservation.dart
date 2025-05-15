import 'package:zomo/models/product.dart';

class Reservation {
  final int? id;
  final int clientId;
  final int transporteurId;
  final int serviceId;
  final String dateReservation;
  final String status;
  final String? commentaire;
  final String typeMenagement;
  final String typeVehicule;
  final double distance;
  final String from;
  final String to;
  final String heureReservation;
  final int etage;
  final List<Product> products;

  Reservation({
    this.id,
    required this.clientId,
    required this.transporteurId,
    required this.serviceId,
    required this.dateReservation,
    required this.status,
    this.commentaire,
    required this.typeMenagement,
    required this.typeVehicule,
    required this.distance,
    required this.from,
    required this.to,
    required this.heureReservation,
    required this.etage,
    required this.products,
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
      typeMenagement: json['type_menagement'],
      typeVehicule: json['type_vehicule'],
      distance: json['distance'].toDouble(),
      from: json['from'],
      to: json['to'],
      heureReservation: json['heure_reservation'],
      etage: json['etage'],
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => Product.fromJson(product))
              .toList() ??
          [],
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
      'type_menagement': typeMenagement,
      'type_vehicule': typeVehicule,
      'distance': distance,
      'from': from,
      'to': to,
      'heure_reservation': heureReservation,
      'etage': etage,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
