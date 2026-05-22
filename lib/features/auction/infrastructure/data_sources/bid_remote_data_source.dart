import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bid_model.dart';

abstract class BidRemoteDataSource {
  Future<List<BidModel>> getPropertyBids(String propertyId, String token);
  Future<BidModel> placeBid(String propertyId, double amount, String token, {String? bankStatementPath});
  Future<BidModel> acceptBid(String bidId, String token);
  Future<BidModel> retractBid(String bidId, String token);
}

class BidRemoteDataSourceImpl implements BidRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  BidRemoteDataSourceImpl({required this.client, this.baseUrl = 'http://localhost:5000/api/v1'});

  @override
  Future<List<BidModel>> getPropertyBids(String propertyId, String token) async {
    final response = await client.get(
      Uri.parse('\$baseUrl/properties/\$propertyId/bids'),
      headers: {'Authorization': 'Bearer \$token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List bids = data['data']['bids'] ?? [];
      return bids.map((json) => BidModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch bids');
    }
  }

  @override
  Future<BidModel> placeBid(String propertyId, double amount, String token, {String? bankStatementPath}) async {
    var request = http.MultipartRequest('POST', Uri.parse('\$baseUrl/properties/\$propertyId/bids'));
    request.headers['Authorization'] = 'Bearer \$token';
    request.fields['amount'] = amount.toString();

    if (bankStatementPath != null) {
      request.files.add(await http.MultipartFile.fromPath('bankStatement', bankStatementPath));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return BidModel.fromJson(data['data']['bid']);
    } else {
      throw Exception('Failed to place bid');
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
      return BidModel.fromJson(data['data']['bid']);
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
      return BidModel.fromJson(data['data']['bid']);
    } else {
      throw Exception('Failed to retract bid');
    }
  }
}
