import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reclamation.dart';
import '../utils/api_config.dart';

class ReclamationService {
  final String baseUrl = ApiConfig.baseUrl;

  // Get all reclamations
  Future<List<Reclamation>> getAllReclamations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reclamations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> reclamationsJson = data['data'];
          return reclamationsJson
              .map((json) => Reclamation.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load reclamations');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create a new reclamation
  Future<bool> createReclamation(Reclamation reclamation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }


      final response = await http.post(
        Uri.parse('$baseUrl/reclamations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(reclamation.toJson()),
      );


      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          Reclamation.fromJson(data['data']);
          return true;
        }
        return false;
      }
      throw Exception('Failed to create reclamation');
    } catch (e) {
      return false;
    }
  }

  // Get a specific reclamation
  Future<Reclamation> getReclamation(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reclamations/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          return Reclamation.fromJson(data['data']);
        }
      }
      throw Exception('Failed to load reclamation');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update a reclamation
  Future<Reclamation> updateReclamation(Reclamation reclamation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/reclamations/${reclamation.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(reclamation.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          return Reclamation.fromJson(data['data']);
        }
      }
      throw Exception('Failed to update reclamation');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete a reclamation
  Future<bool> deleteReclamation(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/reclamations/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['status'] == 'success';
      }
      throw Exception('Failed to delete reclamation');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get reclamations by client ID
  Future<List<Reclamation>> getReclamationsByClientId(int clientId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reclamations/client/$clientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> reclamationsJson = data['data'];
          return reclamationsJson
              .map((json) => Reclamation.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load client reclamations');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get reclamations by transporteur ID
  Future<List<Reclamation>> getReclamationsByTransporteurId(
      int transporteurId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/reclamations/transporteur/$transporteurId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> reclamationsJson = data['data'];
          return reclamationsJson
              .map((json) => Reclamation.fromJson(json))
              .toList();
        }
      }
      throw Exception('Failed to load transporteur reclamations');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
