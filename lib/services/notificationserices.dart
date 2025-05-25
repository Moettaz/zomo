import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../utils/api_config.dart';

class NotificationService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          List<NotificationModel> notifications = (data['data'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList();
          return notifications;
        }
      }
      throw Exception('Failed to load notifications');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
