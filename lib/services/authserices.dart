import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomo/models/client.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/models/chauffeur.dart';
import 'package:zomo/models/user.dart';

class AuthServices {
  // Base URL for the API
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Registration method
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int roleId,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role_id': roleId,
          'phone': phone,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registration successful
        await _saveUserData(responseData);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        // Registration failed
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Login method
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login successful
        await _saveUserData(responseData);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        // Login failed
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Helper method to save user data in SharedPreferences
  static Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // Save token
    await prefs.setString('token', data['token']);

    // Save user data
    if (data['user'] != null) {
      await prefs.setString('user', jsonEncode(data['user']));

      // Save role ID for easy access
      final user = User.fromJson(data['user']);
      await prefs.setInt('role_id', user.roleId);

      // If role-specific data is available, save it based on role
      if (data['specific_data'] != null) {
        await prefs.setString(
            'specific_data', jsonEncode(data['specific_data']));

        if (user.role != null) {
          switch (user.role!.slug) {
            case 'client':
              await prefs.setString('user_type', 'client');
              break;
            case 'transporteur':
              await prefs.setString('user_type', 'transporteur');
              break;
            case 'chauffeur':
              await prefs.setString('user_type', 'chauffeur');
              break;
          }
        }
      }
    }
  }

  // Method to get the current user from SharedPreferences
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final userData = prefs.getString('user');
    final specificData = prefs.getString('specific_data');
    final userType = prefs.getString('user_type');

    if (token == null || userData == null) {
      return null; // Not logged in
    }

    final user = User.fromJson(jsonDecode(userData));

    dynamic typedSpecificData;
    if (specificData != null && userType != null) {
      final decodedData = jsonDecode(specificData);

      switch (userType) {
        case 'client':
          typedSpecificData = Client.fromJson(decodedData);
          break;
        case 'transporteur':
          typedSpecificData = Transporteur.fromJson(decodedData);
          break;
        case 'chauffeur':
          typedSpecificData = Chauffeur.fromJson(decodedData);
          break;
      }
    }

    return {
      'user': user,
      'token': token,
      'specific_data': typedSpecificData,
      'user_type': userType,
    };
  }

  // Logout method
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('specific_data');
    await prefs.remove('user_type');
    await prefs.remove('role_id');
  }

  static Future<Map<String, dynamic>?> updateClient(
      int id, Map<String, String> data,
      {File? imageFile}) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/clients/$id'));
      request.fields.addAll(data);

      // Add _method field to simulate PUT request
      request.fields['_method'] = 'PUT';

      // If image file is provided, attach it to the request
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }
      final prefs = await SharedPreferences.getInstance();

      // Add authorization header
      String? token =  prefs.getString('token');
      if (token != null) {
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update client: ${response.body}');
      }
    } catch (e) {
      return null;
    }
  }

  // Get user profile method
  static Future<Map<String, dynamic>> getProfile(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return {
          'success': false,
          'message': 'Not authenticated',
        };
      }


      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/$userId'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );


      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        // Update the local storage with new data
        await _saveUserData({
          'token': token, // Keep existing token
          'user': responseData['user'],
          'specific_data': responseData['specific_data'],
        });

        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to retrieve profile',
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
