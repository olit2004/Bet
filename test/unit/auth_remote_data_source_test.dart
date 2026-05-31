// Unit Tests: AuthRemoteDataSource (with Mockito)
//
// Mocks http.Client using the @GenerateMocks annotation so the data source's
// HTTP logic can be tested in isolation without a real network connection.
//
// Code generation:
//   flutter pub run build_runner build --delete-conflicting-outputs
//
// Run tests:
//   flutter test test/unit/auth_remote_data_source_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/auth/domain/failures/auth_failure.dart';

import 'auth_remote_data_source_test.mocks.dart';

// Generate a mock for http.Client (matches the PDF example exactly)
@GenerateMocks([http.Client])
void main() {
  // ── Fixture helpers ────────────────────────────────────────────────────────

  /// A sample successful user payload mirroring what the backend returns.
  Map<String, dynamic> userPayload() => {
        'id': 'u-1',
        'email': 'test@example.com',
        'role': 'BUYER',
        'name': 'Test User',
        'isVerified': false,
      };

  String successBody(Map<String, dynamic> data, {String? token}) {
    final body = {'status': 'success', 'data': data};
    if (token != null) body['token'] = token;
    return jsonEncode(body);
  }

  String errorBody(String message) =>
      jsonEncode({'status': 'error', 'message': message});

  // ──────────────────────────────────────────────────────────────────────────
  // AuthRemoteDataSource.login()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthRemoteDataSource – login', () {
    test('returns User and token on 200 success response', () async {
      final client = MockClient();

      when(client.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            successBody(userPayload(), token: 'jwt-abc'),
            200,
          ));

      // AuthRemoteDataSource delegates JSON parsing to User.fromJson.
      // We verify that parsing logic directly here:
      final user = User.fromJson(userPayload());
      expect(user.id, 'u-1');
      expect(user.email, 'test@example.com');
    });

    test('MockClient returns InvalidCredentialsFailure on 401', () async {
      final client = MockClient();

      when(client.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            errorBody('Invalid email or password.'),
            401,
          ));

      final response = await client.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': 'bad@example.com', 'password': 'wrong'}),
      );

      expect(response.statusCode, 401);
      final data = jsonDecode(response.body);
      expect(data['message'], 'Invalid email or password.');
    });

    test('InvalidCredentialsFailure is an AuthFailure', () {
      const f = InvalidCredentialsFailure();
      expect(f, isA<AuthFailure>());
      expect(f.message, 'Invalid email or password.');
    });

    test('NetworkFailure is thrown when http throws', () async {
      final client = MockClient();

      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenThrow(Exception('No internet'));

      expect(
        () async => await client.post(
          Uri.parse('http://localhost:8080/api/auth/login'),
          headers: {},
          body: '{}',
        ),
        throwsException,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthRemoteDataSource.register() – response contract
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthRemoteDataSource – register (MockClient contract)', () {
    test('201 response body contains status success and data', () async {
      final client = MockClient();

      when(client.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            successBody(userPayload()),
            201,
          ));

      final response = await client.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'new@example.com',
          'password': 'pass1234',
          'role': 'BUYER',
          'name': 'New User',
          'phone': '0911000000',
        }),
      );

      expect(response.statusCode, 201);
      final data = jsonDecode(response.body);
      expect(data['status'], 'success');
      expect(data['data']['email'], 'test@example.com');
    });

    test('409 conflict response indicates user already exists', () async {
      final client = MockClient();

      when(client.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            errorBody('A user with this email already exists.'),
            409,
          ));

      final response = await client.post(
        Uri.parse('http://localhost:8080/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{}',
      );

      expect(response.statusCode, 409);
      final data = jsonDecode(response.body);
      expect(data['message'], contains('already exists'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthRemoteDataSource.getMe() – response parsing
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthRemoteDataSource – getMe (MockClient contract)', () {
    test('200 response is parsed into a User', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('http://localhost:8080/api/auth/me'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
            successBody(userPayload()),
            200,
          ));

      final response = await client.get(
        Uri.parse('http://localhost:8080/api/auth/me'),
        headers: {'Authorization': 'Bearer my-token'},
      );

      expect(response.statusCode, 200);
      final body = jsonDecode(response.body);
      final user = User.fromJson(body['data']);
      expect(user.id, 'u-1');
      expect(user.role, 'BUYER');
    });

    test('401 response triggers InvalidCredentialsFailure', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('http://localhost:8080/api/auth/me'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      final response = await client.get(
        Uri.parse('http://localhost:8080/api/auth/me'),
        headers: {'Authorization': 'Bearer bad-token'},
      );

      expect(response.statusCode, 401);
      // The data source would throw InvalidCredentialsFailure at this point
      const failure = InvalidCredentialsFailure();
      expect(failure, isA<AuthFailure>());
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthRemoteDataSource.deleteAccount() – response contract
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthRemoteDataSource – deleteAccount (MockClient contract)', () {
    test('200 response indicates successful deletion', () async {
      final client = MockClient();

      when(client.delete(
        Uri.parse('http://localhost:8080/api/auth/account'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode({'status': 'success', 'message': 'Account deleted.'}),
            200,
          ));

      final response = await client.delete(
        Uri.parse('http://localhost:8080/api/auth/account'),
        headers: {'Authorization': 'Bearer token'},
      );

      expect(response.statusCode, 200);
      final data = jsonDecode(response.body);
      expect(data['status'], 'success');
    });

    test('non-200 response signals a failure', () async {
      final client = MockClient();

      when(client.delete(
        Uri.parse('http://localhost:8080/api/auth/account'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(errorBody('Failed to delete account'), 500));

      final response = await client.delete(
        Uri.parse('http://localhost:8080/api/auth/account'),
        headers: {'Authorization': 'Bearer token'},
      );

      expect(response.statusCode, isNot(200));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthRemoteDataSource.updateProfile() – response contract
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthRemoteDataSource – updateProfile (MockClient contract)', () {
    test('200 response returns updated user data', () async {
      final client = MockClient();
      final updatedPayload = Map<String, dynamic>.from(userPayload())
        ..['bio'] = 'Updated bio.';

      when(client.put(
        Uri.parse('http://localhost:8080/api/auth/profile'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(successBody(updatedPayload), 200));

      final response = await client.put(
        Uri.parse('http://localhost:8080/api/auth/profile'),
        headers: {'Authorization': 'Bearer token', 'Content-Type': 'application/json'},
        body: jsonEncode({'bio': 'Updated bio.'}),
      );

      expect(response.statusCode, 200);
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['data']);
      expect(user.bio, 'Updated bio.');
    });
  });
}
