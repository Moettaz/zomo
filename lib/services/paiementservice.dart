import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zomo/utils/api_config.dart';
import 'package:zomo/models/paiement_model.dart';

class PaymentService {
  final String baseUrl = ApiConfig.baseUrl;

  // Get payments by transporteur ID
  Future<List<Payment>> getPaymentsByTransporteurId(int transporteurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paiements/transporteur/$transporteurId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> paymentsJson = data['data'];
        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }

  // Get payments by client ID
  Future<List<Payment>> getPaymentsByClientId(int clientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paiements/client/$clientId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> paymentsJson = data['data'];
        return paymentsJson.map((json) => Payment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }

  // Create a new payment
  Future<Payment> createPayment(Payment payment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/paiements'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(payment.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Payment.fromJson(data['data']);
      } else {
        throw Exception('Failed to create payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating payment: $e');
    }
  }
}
