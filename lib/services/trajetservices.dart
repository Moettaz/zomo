import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TrajetServices {
  // Base URL for the API - matching the one from AuthServices
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> storeTrajet({
    required int clientId,
    required int transporteurId,
    required int serviceId,
    required String dateHeureDepart,
    required String dateHeureArrivee,
    required String pointDepart,
    required String pointArrivee,
    required double prix,
    required String etat,
  }) async {
    try {
      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/trajets'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'client_id': clientId,
          'transporteur_id': transporteurId,
          'service_id': serviceId,
          'date_heure_depart': dateHeureDepart,
          'date_heure_arrivee': dateHeureArrivee,
          'point_depart': pointDepart,
          'point_arrivee': pointArrivee,
          'prix': prix,
          'etat': etat,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create trajet',
          'errors': responseData['errors'],
          'status_code': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'stack_trace': stackTrace.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getTrajetsByTransporteur(
      int transporteurId) async {
    try {
      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/trajets/transporteur/$transporteurId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch trajets',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getTrajetsByClient(int clientId) async {
    try {
      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/trajets/client/$clientId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch trajets',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateTrajet({
    required int id,
    int? clientId,
    int? transporteurId,
    int? serviceId,
    String? dateHeureDepart,
    String? dateHeureArrivee,
    String? pointDepart,
    String? pointArrivee,
    double? prix,
    double? note,
    String? etat,
  }) async {
    try {
      // Get the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }

      // Create a map of only the provided fields
      final Map<String, dynamic> updateData = {};
      if (clientId != null) updateData['client_id'] = clientId;
      if (transporteurId != null)
        updateData['transporteur_id'] = transporteurId;
      if (serviceId != null) updateData['service_id'] = serviceId;
      if (dateHeureDepart != null)
        updateData['date_heure_depart'] = dateHeureDepart;
      if (dateHeureArrivee != null)
        updateData['date_heure_arrivee'] = dateHeureArrivee;
      if (pointDepart != null) updateData['point_depart'] = pointDepart;
      if (pointArrivee != null) updateData['point_arrivee'] = pointArrivee;
      if (prix != null) updateData['prix'] = prix;
      if (note != null) updateData['note'] = note;
      if (etat != null) updateData['etat'] = etat;

      final response = await http.put(
        Uri.parse('$baseUrl/api/trajets/$id'),
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
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update trajet',
          'errors': responseData['errors'],
          'status_code': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      return {
        'success': false,
        'message': 'Network error: $e',
        'stack_trace': stackTrace.toString(),
      };
    }
  }
}
