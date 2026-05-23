import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bid_model.dart';

abstract class BidRemoteDataSource {
  Future<List<BidModel>> getPropertyBids(String propertyId, String token);
  Future<BidModel> placeBid(String propertyId, double amount, String token, {List<int>? bankStatementBytes, String? bankStatementFileName});
  Future<BidModel> acceptBid(String bidId, String token);
  Future<BidModel> retractBid(String bidId, String token);
}

class BidRemoteDataSourceImpl implements BidRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  BidRemoteDataSourceImpl({required this.client, this.baseUrl = 'http://localhost:8080/api'});

  @override
  Future<List<BidModel>> getPropertyBids(String propertyId, String token) async {
    final response = await client.get(
      Uri.parse('\$baseUrl/properties/\$propertyId/bids'),
      headers: {'Authorization': 'Bearer \$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List bids = data['data'] ?? [];
      return bids.map((json) => BidModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch bids');
    }
  }

  @override
  Future<BidModel> placeBid(String propertyId, double amount, String token, {List<int>? bankStatementBytes, String? bankStatementFileName}) async {
    var request = http.MultipartRequest('POST', Uri.parse('\$baseUrl/properties/\$propertyId/bids'));
    request.headers['Authorization'] = 'Bearer \$token';
    request.fields['amount'] = amount.toString();

    if (bankStatementBytes != null && bankStatementFileName != null) {
      request.files.add(http.MultipartFile.fromBytes('bankStatement', bankStatementBytes, filename: bankStatementFileName));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return BidModel.fromJson(data['data']);
    } else {
      String errorMessage = 'Failed to place bid';
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
  Future<BidModel> acceptBid(String bidId, String token) async {
    final response = await client.patch(
      Uri.parse('\$baseUrl/bids/\$bidId/accept'),
      headers: {'Authorization': 'Bearer \$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BidModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to accept bid');
    }
  }

  @override
  Future<BidModel> retractBid(String bidId, String token) async {
    final response = await client.patch(
      Uri.parse('\$baseUrl/bids/\$bidId/retract'),
      headers: {'Authorization': 'Bearer \$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BidModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to retract bid');
    }
  }
}
