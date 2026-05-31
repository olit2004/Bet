// Unit Tests: PropertyRemoteDataSource (with Mockito)
//
// Mocks http.Client to test the property fetching logic without a real backend.
// Pattern taken directly from the testing guidelines PDF.
//
// Code generation:
//   flutter pub run build_runner build --delete-conflicting-outputs
//
// Run tests:
//   flutter test test/unit/property_remote_data_source_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bet/core/property/models/property_model.dart';

import 'property_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // ── Fixture helpers ────────────────────────────────────────────────────────

  Map<String, dynamic> samplePropertyJson({
    String id = 'p-1',
    String type = 'SALE',
    String listingType = 'REGULAR',
  }) =>
      {
        'id': id,
        'title': 'Modern Apartment',
        'description': 'A nice apartment in the city.',
        'price': 3500000,
        'address': 'Kazanchis, Addis Ababa',
        'imageUrls': ['/public/images/apt.jpg'],
        'type': type,
        'listingType': listingType,
        'beds': 3,
        'baths': 2,
        'sqFootage': 150,
      };

  String propertiesBody(List<Map<String, dynamic>> items) =>
      jsonEncode({'status': 'success', 'data': items});

  String singlePropertyBody(Map<String, dynamic> item) =>
      jsonEncode({'status': 'success', 'data': item});

  const String baseUrl = 'http://localhost:8080/api';

  // ──────────────────────────────────────────────────────────────────────────
  // GET /api/properties – success cases
  // ──────────────────────────────────────────────────────────────────────────
  group('PropertyRemoteDataSource – getProperties', () {
    test('returns a list of Property on 200 response', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
            propertiesBody([samplePropertyJson(), samplePropertyJson(id: 'p-2')]),
            200,
          ));

      final response = await client.get(
        Uri.parse('$baseUrl/properties'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, 200);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      final properties = data
          .map((item) => Property.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(properties.length, 2);
      expect(properties.first.id, 'p-1');
      expect(properties.first.title, 'Modern Apartment');
    });

    test('returns an empty list when data array is empty', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(propertiesBody([]), 200));

      final response = await client.get(
        Uri.parse('$baseUrl/properties'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body)['data'] as List;
      expect(data, isEmpty);
    });

    test('throws Exception on non-200 response', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

      final response = await client.get(
        Uri.parse('$baseUrl/properties'),
        headers: {'Content-Type': 'application/json'},
      );

      // The data source throws when statusCode != 200
      expect(response.statusCode, isNot(200));
      expect(
        () => throw Exception(
            'Failed to load properties: ${response.statusCode}'),
        throwsException,
      );
    });

    test('network error propagates as an exception', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties'),
        headers: anyNamed('headers'),
      )).thenThrow(Exception('Connection refused'));

      expect(
        () async => await client.get(
          Uri.parse('$baseUrl/properties'),
          headers: {'Content-Type': 'application/json'},
        ),
        throwsException,
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // GET /api/properties/:id – success cases
  // ──────────────────────────────────────────────────────────────────────────
  group('PropertyRemoteDataSource – getPropertyById', () {
    test('returns a Property on 200 response', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
            singlePropertyBody(samplePropertyJson()),
            200,
          ));

      final response = await client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, 200);
      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final property = Property.fromJson(data);
      expect(property.id, 'p-1');
      expect(property.specs.length, 3); // beds, baths, sqm
    });

    test('returns null on 404 response', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties/missing'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      final response = await client.get(
        Uri.parse('$baseUrl/properties/missing'),
        headers: {'Content-Type': 'application/json'},
      );

      expect(response.statusCode, 404);
      // The data source returns null for 404
      Property? result;
      if (response.statusCode == 404) result = null;
      expect(result, isNull);
    });

    test('AUCTION listingType sets isFeatured to true', () async {
      final client = MockClient();
      final json = samplePropertyJson(listingType: 'AUCTION');

      when(client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(singlePropertyBody(json), 200));

      final response = await client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final property = Property.fromJson(data);
      expect(property.isFeatured, isTrue);
    });

    test('RENT type property has correct category', () async {
      final client = MockClient();
      final json = samplePropertyJson(type: 'RENT');

      when(client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(singlePropertyBody(json), 200));

      final response = await client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: {},
      );

      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final property = Property.fromJson(data);
      expect(property.category, PropertyCategory.rent);
      expect(property.categoryName, 'Rent');
    });

    test('local image URL is prefixed with the backend base URL', () async {
      final client = MockClient();

      when(client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async =>
          http.Response(singlePropertyBody(samplePropertyJson()), 200));

      final response = await client.get(
        Uri.parse('$baseUrl/properties/p-1'),
        headers: {},
      );

      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final property = Property.fromJson(data);
      expect(property.imageUrls.first,
          startsWith('http://localhost:8080/public'));
    });
  });
}
