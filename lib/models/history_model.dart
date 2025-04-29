class HistoryModel {
  final String title;
  final String demandeId;
  final String date;
  final String time;
  final String transporteur;
  final String emplacement;
  final String point;
  final String status;
  final double amount;
  final bool isTransporteur;

  HistoryModel({
    required this.isTransporteur,
    required this.title,
    required this.demandeId,
    required this.date,
    required this.time,
    required this.transporteur,
    required this.emplacement,
    required this.point,
    required this.status,
    required this.amount,
  });

  // Convert Map to HistoryModel
  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      isTransporteur: map["isTansporteur"] as bool,
      title: map['title'] as String,
      demandeId: map['demandeId'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      transporteur: map['transporteur'] as String,
      emplacement: map['emplacement'] as String,
      point: map['point'] as String,
      status: map['status'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  // Convert HistoryModel to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'demandeId': demandeId,
      'isTransporteur' :isTransporteur,
      'date': date,
      'time': time,
      'transporteur': transporteur,
      'emplacement': emplacement,
      'point': point,
      'status': status,
      'amount': amount,
    };
  }
}
