import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomo/models/transporteur.dart';

class TransporteurServices {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Get all transporteurs
  static Future<List<Transporteur>> getAllTransporteurs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print('Getting transporteurs with token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/transporteurs'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Decoded response data: $responseData');

        if (responseData['success'] == true && responseData['data'] != null) {
          final transporteurs = (responseData['data'] as List)
              .map((data) => Transporteur.fromJson(data))
              .toList();
          print('Number of transporteurs: ${transporteurs.length}');
          return transporteurs;
        }
        print('No transporteurs found in response');
        return [];
      } else {
        print('Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load transporteurs: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error getting transporteurs: $e');
      print('Stack trace: $stackTrace'); 
      return [];
    }
  }

  // Get a single transporteur by ID
  static Future<Transporteur?> getTransporteur(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('$baseUrl/api/transporteurs/$id'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return Transporteur.fromJson(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting transporteur: $e');
      return null;
    }
  }

  // Create a new transporteur
  static Future<Map<String, dynamic>> createTransporteur(
      Map<String, dynamic> data, {File? imageFile}) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/transporteurs'));

      request.fields.addAll(
          data.map((key, value) => MapEntry(key, value.toString())));

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Creation failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Update a transporteur
  static Future<Map<String, dynamic>> updateTransporteur(
      int id, Map<String, dynamic> data, {File? imageFile}) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/api/transporteurs/$id'));

      // Add _method field to simulate PUT request
      request.fields['_method'] = 'PUT';
      request.fields.addAll(
          data.map((key, value) => MapEntry(key, value.toString())));

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token != null) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Delete a transporteur
  static Future<Map<String, dynamic>> deleteTransporteur(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('$baseUrl/api/transporteurs/$id'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Transporteur deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Deletion failed',
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
