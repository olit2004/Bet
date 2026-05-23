import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

class PropertyRemoteDataSource {
  // Must match the same base URL used in auth
  static const String _baseUrl = 'http://localhost:8080/api';

  /// Fetches all properties from the backend.
  Future<List<Property>> getProperties() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/properties'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      return data
          .map((item) => Property.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load properties: ${response.statusCode}');
    }
  }

  /// Fetches a single property by ID from the backend.
  /// Increments the view count (buyer is viewing).
  Future<Property?> getPropertyById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/properties/$id?incrementView=true'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return Property.fromJson(body['data'] as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load property: ${response.statusCode}');
    }
  }
}
