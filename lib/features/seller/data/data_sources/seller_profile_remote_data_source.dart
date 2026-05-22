import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';
import '../../domain/entities/seller_profile_stats.dart';
import '../models/seller_profile_stats_model.dart';

class SellerProfileRemoteDataSource {
  final AuthLocalDataSource _authLocalDataSource;
  static const String baseUrl = 'http://localhost:8080/api/properties/seller';

  SellerProfileRemoteDataSource({
    required AuthLocalDataSource authLocalDataSource,
  }) : _authLocalDataSource = authLocalDataSource;

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authLocalDataSource.getToken();
    if (token == null) {
      throw Exception('Not authenticated. Please log in again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<SellerProfileStats> getSellerStats(String sellerId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$sellerId/stats'),
        headers: headers,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return SellerProfileStatsModel.fromJson(data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception(data['message'] as String? ?? 'Failed to fetch seller stats.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }
}
