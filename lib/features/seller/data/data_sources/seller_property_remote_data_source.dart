import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';
import '../models/seller_property_model.dart';

/// Handles all HTTP communication for seller property operations.
class SellerPropertyRemoteDataSource {
  final AuthLocalDataSource _authLocalDataSource;

  // Using localhost for Desktop testing (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = 'http://localhost:8080/api/properties';

  SellerPropertyRemoteDataSource({
    required AuthLocalDataSource authLocalDataSource,
  }) : _authLocalDataSource = authLocalDataSource;

  /// Retrieves the cached JWT token and builds the authorization headers.
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authLocalDataSource.getToken();
    if (token == null) {
      throw Exception('Not authenticated. Please log in again.');
    }
    return {
      'Authorization': 'Bearer $token',
    };
  }

  /// Creates a new property listing on the backend.
  /// The backend extracts the ownerId from the JWT, so we don't send it.
  Future<Map<String, dynamic>> createProperty(
      Map<String, dynamic> propertyData) async {
    try {
      final headers = await _getAuthHeaders();
      final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers.addAll(headers);

      // Add text fields
      propertyData.forEach((key, value) {
        if (key != 'images' && value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add image files
      if (propertyData.containsKey('images')) {
        final List<XFile> images = propertyData['images'] as List<XFile>;
        for (final image in images) {
          final bytes = await image.readAsBytes();
          
          final ext = image.name.split('.').last.toLowerCase();
          MediaType contentType = MediaType('image', 'jpeg');
          if (ext == 'png') {
            contentType = MediaType('image', 'png');
          } else if (ext == 'webp') {
            contentType = MediaType('image', 'webp');
          }

          request.files.add(
            http.MultipartFile.fromBytes(
              'images',
              bytes,
              filename: image.name,
              contentType: contentType,
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 && data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else if (response.statusCode == 403) {
        throw Exception('Only sellers can create property listings.');
      } else {
        throw Exception(
            data['message'] as String? ?? 'Failed to create property.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }

  /// Fetches all properties created by a specific seller.
  Future<List<SellerPropertyModel>> getSellerProperties(String sellerId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/seller/$sellerId'),
        headers: headers,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> propertiesJson = data['data'] as List<dynamic>;
        return propertiesJson
            .map((json) =>
                SellerPropertyModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception(
            data['message'] as String? ?? 'Failed to fetch properties.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }

  /// Fetches a specific property by its ID.
  Future<SellerPropertyModel> getPropertyById(String propertyId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/$propertyId'),
        headers: headers,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && data['success'] == true) {
        return SellerPropertyModel.fromJson(
            data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw Exception('Property not found.');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception(
            data['message'] as String? ?? 'Failed to fetch property details.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }

  /// Accepts an offer (bid or proposal).
  Future<void> acceptOffer(String offerId, bool isAuction) async {
    try {
      final headers = await _getAuthHeaders();
      headers['Content-Type'] = 'application/json';

      final url = isAuction
          ? 'http://localhost:8080/api/bids/$offerId/accept'
          : 'http://localhost:8080/api/proposals/$offerId/status';

      final body = isAuction ? null : jsonEncode({'status': 'ACCEPTED'});

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(
            data['message'] as String? ?? 'Failed to accept offer.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your connection.');
    }
  }
}
