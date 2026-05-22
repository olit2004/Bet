import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';
import '../../domain/entities/buyer_profile.dart';
import '../../domain/entities/buyer_dashboard.dart';

class BuyerRemoteDataSource {
  static const String baseUrl = 'http://localhost:8080/api/buyer';
  final AuthLocalDataSource _authLocalDataSource;

  BuyerRemoteDataSource({AuthLocalDataSource? authLocalDataSource}) 
      : _authLocalDataSource = authLocalDataSource ?? AuthLocalDataSource();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authLocalDataSource.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<BuyerProfile> registerAsBuyer() async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['status'] == 'success') {
      return BuyerProfile.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to register as buyer');
    }
  }

  Future<BuyerProfile> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return BuyerProfile.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to load profile');
    }
  }

  Future<BuyerProfile> updateProfile({
    String? email,
    String? name,
    String? phone,
    double? budget,
    String? preferredPropertyType,
    List<String>? preferredLocations,
  }) async {
    final body = <String, dynamic>{};
    if (email != null) body['email'] = email;
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (budget != null) body['budget'] = budget;
    if (preferredPropertyType != null) body['preferredPropertyType'] = preferredPropertyType;
    if (preferredLocations != null) body['preferredLocations'] = preferredLocations;

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return BuyerProfile.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to update profile');
    }
  }

  Future<BuyerProfile> verifyFayda({
    required String faydaId,
    String? imagePath,
    List<int>? imageBytes,
    String? fileName,
  }) async {
    final headers = await _getHeaders();
    // Remove Content-Type so http sets it automatically for multipart
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse('$baseUrl/verify-fayda'),
    );
    request.headers.addAll(headers);
    request.fields['faydaId'] = faydaId;
    
    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'faydaImage', 
        imageBytes,
        filename: fileName ?? 'fayda_upload.jpg'
      ));
    } else if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('faydaImage', imagePath));
    } else {
      throw Exception('Either imagePath or imageBytes must be provided');
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) && data['status'] == 'success') {
      return BuyerProfile.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Failed to submit Fayda ID');
    }
  }

  Future<BuyerDashboard> getDashboard() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return BuyerDashboard.fromJson(data['data']['statistics']);
    } else {
      throw Exception(data['message'] ?? 'Failed to load dashboard');
    }
  }
}
