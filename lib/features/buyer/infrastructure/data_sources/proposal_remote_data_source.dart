import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';

class ProposalRemoteDataSource {
  static const String baseUrl = 'http://localhost:8080/api/proposals';
  final AuthLocalDataSource _authLocalDataSource;

  ProposalRemoteDataSource({AuthLocalDataSource? authLocalDataSource})
      : _authLocalDataSource = authLocalDataSource ?? AuthLocalDataSource();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authLocalDataSource.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Create a proposal (counter offer) on a rental property.
  /// Optionally attach a proposal PDF file.
  Future<Map<String, dynamic>> createProposal({
    required String propertyId,
    required String details,
    double? amount,
    String? proposalFilePath,
    List<int>? proposalFileBytes,
    String? proposalFileName,
  }) async {
    final headers = await _getHeaders();
    headers.remove('Content-Type');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/property/$propertyId'),
    );
    request.headers.addAll(headers);
    request.fields['details'] = details;
    if (amount != null) {
      request.fields['amount'] = amount.toString();
    }

    if (proposalFileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'proposalFile',
        proposalFileBytes,
        filename: proposalFileName ?? 'proposal.pdf',
      ));
    } else if (proposalFilePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('proposalFile', proposalFilePath),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data['status'] == 'success') {
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(data['message'] ?? 'Failed to create proposal');
    }
  }

  /// Get all proposals for the currently logged-in buyer.
  Future<List<Map<String, dynamic>>> getMyProposals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/my-proposals'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception(data['message'] ?? 'Failed to load proposals');
    }
  }
}
