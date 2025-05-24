import 'dart:convert';
import 'package:http/http.dart' as http;

class CallHistoryService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<bool> storeCallHistory({
    required int senderId,
    required int receiverId,
    required String etat,
    int? duration,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/call-history'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'sender_id': senderId,
          'receiver_id': receiverId,
          'etat': etat,
          'duration': duration,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getCallHistoryById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/call-history/$userId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get call history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting call history: $e');
    }
  }
}
