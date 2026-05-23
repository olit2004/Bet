import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/buyer_dashboard.dart';

abstract class BuyerRemoteDataSource {
  Future<BuyerDashboard> getBuyerDashboard(String token);
}

class BuyerRemoteDataSourceImpl implements BuyerRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://localhost:8080/api/buyer';

  BuyerRemoteDataSourceImpl({required this.client});

  @override
  Future<BuyerDashboard> getBuyerDashboard(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return BuyerDashboard.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to load buyer dashboard');
      }
    } else {
      throw Exception('Failed to load buyer dashboard (status code: ${response.statusCode})');
    }
  }
}
