import 'dart:convert';

class NotificationModel {
  final int id;
  final String senderId;
  final String receiverId;
  final String? serviceId;
  final String type;
  final String message;
  final String status;
  final DateTime dateNotification;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.serviceId,
    required this.type,
    required this.message,
    required this.status,
    required this.dateNotification,
  });

  // Convert Map to NotificationModel
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      senderId: map['sender_id'] as String,
      receiverId: map['receiver_id'] as String,
      serviceId: map['service_id'] as String?,
      type: map['type'] as String,
      message: map['message'] as String,
      status: map['status'] as String,
      dateNotification: DateTime.parse(map['date_notification'] as String),
    );
  }

  // Convert NotificationModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'service_id': serviceId,
      'type': type,
      'message': message,
      'status': status,
      'date_notification': dateNotification.toIso8601String(),
    };
  }

  // From JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      serviceId: json['service_id']?.toString(),
      type: json['type'],
      message: json['message'],
      status: json['status'],
      dateNotification: DateTime.parse(json['date_notification']),
    );
  }

  // To JSON
  String toJson() => json.encode(toMap());
}
