import '../../domain/entities/seller_property.dart';
import '../models/seller_property_model.dart';
import '../../domain/repositories/seller_property_repository.dart';
import '../data_sources/seller_property_remote_data_source.dart';

class SellerPropertyRepositoryImpl implements SellerPropertyRepository {
  final SellerPropertyRemoteDataSource _remoteDataSource;

  SellerPropertyRepositoryImpl({
    required SellerPropertyRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<SellerProperty> createProperty(
      Map<String, dynamic> propertyData) async {
    final json = await _remoteDataSource.createProperty(propertyData);
    return SellerPropertyModel.fromJson(json);
  }

  @override
  Future<List<SellerProperty>> getSellerProperties(String sellerId) async {
    return await _remoteDataSource.getSellerProperties(sellerId);
  }

  @override
  Future<SellerProperty> getPropertyById(String propertyId) async {
    return await _remoteDataSource.getPropertyById(propertyId);
  }

  @override
  Future<void> acceptOffer(String offerId, bool isAuction) async {
    return await _remoteDataSource.acceptOffer(offerId, isAuction);
  }
}
