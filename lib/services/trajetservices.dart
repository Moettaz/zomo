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
      // Input validation
      if (clientId <= 0) throw Exception('Invalid client ID');
      if (transporteurId <= 0) throw Exception('Invalid transporteur ID');
      if (serviceId <= 0) throw Exception('Invalid service ID');
      if (pointDepart.isEmpty) throw Exception('Point depart cannot be empty');
      if (pointArrivee.isEmpty)
        throw Exception('Point arrivee cannot be empty');
      if (prix <= 0) throw Exception('Prix must be greater than 0');

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

      print('Sending request to create trajet with data:');
      print('Client ID: $clientId');
      print('Transporteur ID: $transporteurId');
      print('Service ID: $serviceId');
      print('Point depart: $pointDepart');
      print('Point arrivee: $pointArrivee');

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

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('Successfully created trajet');
        return {
          'success': true,
          'data': responseData['data'],
        };
      } else {
        print('Failed to create trajet. Status code: ${response.statusCode}');
        print('Error message: ${responseData['message']}');
        print('Error details: ${responseData['errors']}');

        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create trajet',
          'errors': responseData['errors'],
          'status_code': response.statusCode,
        };
      }
    } catch (e, stackTrace) {
      print('Exception occurred while creating trajet:');
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
}
