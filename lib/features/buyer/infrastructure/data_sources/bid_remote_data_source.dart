import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';

class BidRemoteDataSource {
  static const String baseUrl = 'http://localhost:8080/api';
  final AuthLocalDataSource _authLocalDataSource;

  BidRemoteDataSource({AuthLocalDataSource? authLocalDataSource})
      : _authLocalDataSource = authLocalDataSource ?? AuthLocalDataSource();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authLocalDataSource.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Place a bid on a property (AUCTION type).
  /// Optionally attach a bank statement file.
  Future<Map<String, dynamic>> placeBid({
    required String propertyId,
    required double amount,
    String? bankStatementPath,
    List<int>? bankStatementBytes,
    String? bankStatementFileName,
  }) async {
    final headers = await _getHeaders();
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/properties/$propertyId/bids'),
    );
    request.headers.addAll(headers);
    request.fields['amount'] = amount.toString();

    if (bankStatementBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'bankStatement',
        bankStatementBytes,
        filename: bankStatementFileName ?? 'bank_statement.pdf',
      ));
    } else if (bankStatementPath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('bankStatement', bankStatementPath),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data['status'] == 'success') {
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(data['message'] ?? 'Failed to place bid');
    }
  }

  /// Get all bids for the currently logged-in buyer.
  Future<List<Map<String, dynamic>>> getMyBids() async {
    final response = await http.get(
      Uri.parse('$baseUrl/my-bids'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception(data['message'] ?? 'Failed to load bids');
    }
  }

  /// Retract (cancel) a bid.
  Future<Map<String, dynamic>> retractBid(String bidId) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/bids/$bidId/retract'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(data['message'] ?? 'Failed to retract bid');
    }
  }
}
