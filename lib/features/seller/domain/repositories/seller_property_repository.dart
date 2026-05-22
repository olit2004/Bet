import '../entities/seller_property.dart';

/// Abstract contract for seller property operations.
abstract class SellerPropertyRepository {
  /// Creates a new property listing.
  /// Returns the created [SellerProperty] from the server.
  Future<SellerProperty> createProperty(Map<String, dynamic> propertyData);
}
