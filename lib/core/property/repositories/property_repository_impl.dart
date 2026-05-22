import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';
import './property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  static const String baseUrl = 'http://localhost:8080/api';

  @override
  Future<List<Property>> getProperties() async {
    final response = await http.get(Uri.parse('$baseUrl/properties'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['success'] == true) {
        final List<dynamic> data = body['data'];
        return data.map((json) => Property.fromJson(json)).toList();
      }
      throw Exception(body['message'] ?? 'Failed to load properties');
    }
    throw Exception('Failed to connect to backend: ${response.statusCode}');
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/properties/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body['success'] == true) {
        return Property.fromJson(body['data']);
      }
      return null;
    }
    return null;
  }

  @override
  Future<List<Property>> searchProperties(String query) async {
    // Currently relying on local filtering from all properties since backend search isn't defined yet
    final allProperties = await getProperties();
    final lowercaseQuery = query.toLowerCase();
    return allProperties.where((p) {
      return p.title.toLowerCase().contains(lowercaseQuery) ||
             p.address.toLowerCase().contains(lowercaseQuery) ||
             p.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Property>> getPropertiesByCategory(PropertyCategory category) async {
    final allProperties = await getProperties();
    return allProperties.where((p) => p.category == category).toList();
  }
}
