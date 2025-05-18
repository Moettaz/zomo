import 'package:zomo/models/client.dart';

class MissionModel {
  final String id;
  final Client client;
  final String from;
  final String to;
  final DateTime date;
  final String time;
  final String status;
  final List<MissionItem> items;

  MissionModel({
    required this.id,
    required this.client,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.status,
    required this.items,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    return MissionModel(
      id: json['id'],
      client: json['client'],
      from: json['from'],
      to: json['to'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      items: json['items'].map((item) => MissionItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'from': from,
      'to': to,
      'date': date,
      'time': time,
      'status': status,
      'items': items,
    };
  }
}

class MissionItem {
  final String id;
  final String name;
  final int quantity;

  MissionItem({
    required this.id,
    required this.name,
    required this.quantity,
  });

  factory MissionItem.fromJson(Map<String, dynamic> json) {
    return MissionItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }
}
