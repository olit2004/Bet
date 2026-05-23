import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/proposal_model.dart';

abstract class ProposalRemoteDataSource {
  Future<List<ProposalModel>> getMyProposals(String token);
  Future<List<ProposalModel>> getProposalsByProperty(String propertyId, String token);
  Future<ProposalModel> createProposal(String propertyId, String token, {String? proposalFilePath, List<int>? fileBytes, String? fileName, double? amount, String? details});
  Future<ProposalModel> updateProposalStatus(String proposalId, String status, String token);
}

class ProposalRemoteDataSourceImpl implements ProposalRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProposalRemoteDataSourceImpl({required this.client, this.baseUrl = 'http://localhost:8080/api'});

  @override
  Future<List<ProposalModel>> getMyProposals(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/proposals/my-proposals'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List proposals = data['data'] ?? [];
      return proposals.map((json) => ProposalModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch my proposals');
    }
  }

  @override
  Future<List<ProposalModel>> getProposalsByProperty(String propertyId, String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/proposals/property/$propertyId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List proposals = data['data'] ?? [];
      return proposals.map((json) => ProposalModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch property proposals');
    }
  }

  @override
  Future<ProposalModel> createProposal(String propertyId, String token, {String? proposalFilePath, List<int>? fileBytes, String? fileName, double? amount, String? details}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/proposals/property/$propertyId'));
    request.headers['Authorization'] = 'Bearer $token';

    if (amount != null) {
      request.fields['amount'] = amount.toString();
    }
    if (details != null && details.isNotEmpty) {
      request.fields['details'] = details;
    }

    if (fileBytes != null && fileName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'proposalFile', 
        fileBytes, 
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ));
    } else if (proposalFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('proposalFile', proposalFilePath));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ProposalModel.fromJson(data['data']);
    } else {
      String errorMessage = 'Failed to create proposal';
      try {
        final data = jsonDecode(response.body);
        if (data['message'] != null) {
          errorMessage = data['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  @override
  Future<ProposalModel> updateProposalStatus(String proposalId, String status, String token) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/proposals/$proposalId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProposalModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to update proposal status');
    }
  }
}
