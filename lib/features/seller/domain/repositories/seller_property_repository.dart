import '../entities/seller_property.dart';

/// Abstract contract for seller property operations.
abstract class SellerPropertyRepository {
  /// Creates a new property listing.
  /// Returns the created [SellerProperty] from the server.
  Future<SellerProperty> createProperty(Map<String, dynamic> propertyData);

  /// Retrieves all properties created by a specific seller.
  Future<List<SellerProperty>> getSellerProperties(String sellerId);

  /// Retrieves a specific property by its ID.
  Future<SellerProperty> getPropertyById(String propertyId);

  /// Accepts a bid or proposal.
  Future<void> acceptOffer(String offerId, bool isAuction);
}
