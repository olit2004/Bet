import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/seller_property.dart';
import 'create_property_provider.dart';

/// Fetches detailed information for a specific property.
final propertyDetailProvider =
    FutureProvider.family<SellerProperty, String>((ref, propertyId) async {
  final repository = ref.watch(sellerPropertyRepositoryProvider);
  return await repository.getPropertyById(propertyId);
});
