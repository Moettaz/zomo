import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation.dart';
import '../models/product.dart';

class ReservationServices {
  // Base URL for the API - matching the one from other services
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Create a new reservation
  static Future<Map<String, dynamic>> storeReservation({
    required int clientId,
    required int transporteurId,
    required int serviceId,
    required String dateReservation,
    required String status,
    String? commentaire,
    String? colisSize,
    String? typeMenagement,
    String? typeVehicule,
    String? distance,
    required String from,
    required String to,
    String? heureReservation,
    int? etage,   
    List<Product>? products,
  }) async {
    try {
      // Input validation
      if (clientId <= 0) throw Exception('Invalid client ID');
      if (transporteurId <= 0) throw Exception('Invalid transporteur ID');
      if (serviceId <= 0) throw Exception('Invalid service ID');
      if (dateReservation.isEmpty)
        throw Exception('Date reservation cannot be empty');
      if (status.isEmpty) throw Exception('Status cannot be empty');
      if (typeMenagement != null && typeMenagement.isEmpty)
        throw Exception('Type menagement cannot be empty');
      if (typeVehicule != null && typeVehicule.isEmpty)
        throw Exception('Type vehicule cannot be empty');
      if (from.isEmpty) throw Exception('From location cannot be empty');
      if (to.isEmpty) throw Exception('To location cannot be empty');
      if (heureReservation != null && heureReservation.isEmpty)
        throw Exception('Heure reservation cannot be empty');

      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Authentication error: Token is null');
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      print('Sending request to create reservation with data:');
      print('Client ID: $clientId');
      print('Transporteur ID: $transporteurId');
      print('Service ID: $serviceId');
      print('Date Reservation: $dateReservation');
      print('Status: $status');

      final response = await http.post(
        Uri.parse('$baseUrl/api/reservations'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'client_id': clientId,
          'transporteur_id': transporteurId,
          'service_id': serviceId,
          'date_reservation': dateReservation,
          'status': status,
          if (commentaire != null) 'commentaire': commentaire,
          if (colisSize != null) 'colis_size': colisSize,
          if (typeMenagement != null) 'type_menagement': typeMenagement,
          if (typeVehicule != null) 'type_vehicule': typeVehicule,
          if (distance != null) 'distance': distance,
          'from': from,
          'to': to,
          if (heureReservation != null) 'heure_reservation': heureReservation,
          if (etage != null) 'etage': etage,
          if (products != null)
            'products': products.map((product) => product.toJson()).toList(),
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('Successfully created reservation');
        return {
          'success': true,
          'data': Reservation.fromJson(responseData['data']),
        };
      } else {
        print(
            'Failed to create reservation. Status code: ${response.statusCode}');
        print('Error message: ${responseData['message']}');
        print('Error details: ${responseData['errors']}');

        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create reservation',
          'errors': responseData['errors'],
          'status_code': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      print('Exception occurred while creating reservation:');
      print(e);
      print('Stack trace:');
      print(stackTrace);

      return {
        'success': false,
        'message': 'Network error: $e',
        'stack_trace': stackTrace.toString(),
      };
    }
  }

  // Get all reservations for a transporteur
  static Future<Map<String, dynamic>> getReservationsByTransporteur(
      int transporteurId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/reservations/transporteur/$transporteurId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<Reservation> reservations = (responseData['data'] as List)
            .map((json) => Reservation.fromJson(json))
            .toList();
        return {
          'success': true,
          'data': reservations,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch reservations',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Get all reservations for a client
  static Future<Map<String, dynamic>> getReservationsByClient(
      int clientId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      print('Fetching reservations for client $clientId');
      print('Using token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/reservations/client/$clientId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] as List;
        print('Number of reservations: ${data.length}');
        
        final List<Reservation> reservations = data
            .map((json) {
              print('Processing reservation: $json');
              return Reservation.fromJson(json);
            })
            .toList();
            
        return {
          'success': true,
          'data': reservations,
        };
      } else {
        print('Error response: $responseData');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch reservations',
        };
      }
    } catch (e, stackTrace) {
      print('Error fetching reservations: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Get a specific reservation
  static Future<Map<String, dynamic>> getReservation(int reservationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/reservations/$reservationId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': Reservation.fromJson(responseData['data']),
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch reservation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Update a reservation
  static Future<Map<String, dynamic>> updateReservation({
    required int reservationId,
    int? clientId,
    int? transporteurId,
    int? serviceId,
    String? dateReservation,
    String? status,
    String? commentaire,
    String? typeMenagement,
    String? typeVehicule,
    double? distance,
    String? from,
    String? to,
    String? heureReservation,
    int? etage,
    List<Product>? products,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final Map<String, dynamic> updateData = {
        if (clientId != null) 'client_id': clientId,
        if (transporteurId != null) 'transporteur_id': transporteurId,
        if (serviceId != null) 'service_id': serviceId,
        if (dateReservation != null) 'date_reservation': dateReservation,
        if (status != null) 'status': status,
        if (commentaire != null) 'commentaire': commentaire,
        if (typeMenagement != null) 'type_menagement': typeMenagement,
        if (typeVehicule != null) 'type_vehicule': typeVehicule,
        if (distance != null) 'distance': distance,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (heureReservation != null) 'heure_reservation': heureReservation,
        if (etage != null) 'etage': etage,
        if (products != null)
          'products': products.map((product) => product.toJson()).toList(),
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/reservations/$reservationId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': Reservation.fromJson(responseData['data']),
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update reservation',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Delete a reservation
  static Future<Map<String, dynamic>> deleteReservation(
      int reservationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/reservations/$reservationId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Reservation deleted successfully',
        };
      } else {
        final responseData = jsonDecode(response.body);
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to delete reservation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}
