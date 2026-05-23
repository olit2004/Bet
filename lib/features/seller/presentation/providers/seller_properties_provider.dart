import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seller_property.dart';
import 'create_property_provider.dart';

/// Fetches all properties created by a specific seller.
final sellerPropertiesProvider =
    FutureProvider.family<List<SellerProperty>, String>((ref, sellerId) async {
  final repository = ref.watch(sellerPropertyRepositoryProvider);
  try {
    return await repository.getSellerProperties(sellerId);
  } catch (e) {
    throw Exception('Failed to load properties. Please try again later.');
  }
});
