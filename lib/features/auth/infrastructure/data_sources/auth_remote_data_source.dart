import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/failures/auth_failure.dart';
import '../../domain/entities/user.dart';

class AuthRemoteDataSource {
  // Using localhost for Windows Desktop testing (use 10.0.2.2 for Android Emulator)
  static const String baseUrl = 'http://localhost:8080/api/auth';

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
}
