import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  // Using localhost for Windows Desktop testing (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = 'http://localhost:8080/api/auth';

  Future<User> getMe(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return User.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsFailure();
      } else {
        throw AuthFailure(data['message'] ?? 'Failed to fetch user');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'user': User.fromJson(data['data']),
          'token': data['token'],
        };
      } else if (response.statusCode == 401) {
        throw const InvalidCredentialsFailure();
      } else {
        throw AuthFailure(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
    String? company,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
          'name': name,
          'phone': phone,
          if (company != null) 'company': company,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == 'success') {
        // The API returns the user, but we need them to login to get a token.
        // Actually, we can return the user here.
        return {
          'user': User.fromJson(data['data']),
        };
      } else if (response.statusCode == 409) {
        throw const UserAlreadyExistsFailure();
      } else {
        throw AuthFailure(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<User> uploadProfileImage(XFile image, String token) async {
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse('$baseUrl/profile-image'));
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      final bytes = await image.readAsBytes();
      final mimeType = image.mimeType ?? 'image/jpeg';
      final typeSplit = mimeType.split('/');
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: image.name,
          contentType: MediaType(typeSplit[0], typeSplit.length > 1 ? typeSplit[1] : 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return User.fromJson(data['data']);
      } else {
        throw AuthFailure(data['message'] ?? 'Failed to upload image');
      }
    } catch (e, stack) {
      print('Upload error: $e');
      print('Upload stack: $stack');
      if (e is AuthFailure) rethrow;
      throw const NetworkFailure();
    }
  }

  Future<User> submitVerification(String faydaId, XFile image, String token) async {
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse('$baseUrl/verification'));
      
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['faydaId'] = faydaId;

      final bytes = await image.readAsBytes();
      final mimeType = image.mimeType ?? 'image/jpeg';
      final typeSplit = mimeType.split('/');
      
      request.files.add(
        http.MultipartFile.fromBytes(
          'faydaImage',
          bytes,
          filename: image.name,
          contentType: MediaType(typeSplit[0], typeSplit.length > 1 ? typeSplit[1] : 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return User.fromJson(data['data']);
      } else if (response.statusCode == 409) {
        throw const AuthFailure('This Fayda ID is already registered.');
      } else {
        throw AuthFailure(data['message'] ?? 'Failed to submit verification');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw const NetworkFailure();
    }
  }
}
