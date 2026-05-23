import '../../domain/entities/seller_property.dart';
import '../models/seller_property_model.dart';
import '../../domain/repositories/seller_property_repository.dart';
import '../data_sources/seller_property_remote_data_source.dart';

import '../data_sources/seller_property_local_data_source.dart';

class SellerPropertyRepositoryImpl implements SellerPropertyRepository {
  final SellerPropertyRemoteDataSource _remoteDataSource;
  final SellerPropertyLocalDataSource _localDataSource;

  SellerPropertyRepositoryImpl({
    required SellerPropertyRemoteDataSource remoteDataSource,
    required SellerPropertyLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<SellerProperty> createProperty(
    Map<String, dynamic> propertyData,
  ) async {
    final json = await _remoteDataSource.createProperty(propertyData);
    final property = SellerPropertyModel.fromJson(json);
    await _localDataSource.cacheProperty(property);
    return property;
  }

  @override
  Future<List<SellerProperty>> getSellerProperties(String sellerId) async {
    final localProperties = await _localDataSource.getSellerProperties(
      sellerId,
    );

    if (localProperties.isNotEmpty) {
      _fetchAndCachePropertiesInBackground(sellerId);
      return localProperties;
    }

    return await _fetchAndCacheProperties(sellerId);
  }

  Future<List<SellerProperty>> _fetchAndCacheProperties(String sellerId) async {
    try {
      final properties = await _remoteDataSource.getSellerProperties(sellerId);

      final models = properties.whereType<SellerPropertyModel>().toList();
      await _localDataSource.cacheSellerProperties(sellerId, models);
      return properties;
    } catch (e) {
      return [];
    }
  }

  void _fetchAndCachePropertiesInBackground(String sellerId) {
    _fetchAndCacheProperties(sellerId).catchError((_) {
      return <SellerProperty>[];
    });
  }

  @override
  Future<SellerProperty> getPropertyById(String propertyId) async {
    try {
      final property = await _remoteDataSource.getPropertyById(propertyId);
      await _localDataSource.cacheProperty(property as SellerPropertyModel);
      return property;
    } catch (e) {
      final localProperty = await _localDataSource.getPropertyById(propertyId);
      if (localProperty != null) {
        return localProperty;
      }
      rethrow;
    }
  }

  @override
  Future<void> acceptOffer(String offerId, bool isAuction) async {
    return await _remoteDataSource.acceptOffer(offerId, isAuction);
  }

  @override
  Future<SellerProperty> updateProperty(
    String propertyId,
    Map<String, dynamic> propertyData,
  ) async {
    final updatedModel = await _remoteDataSource.updateProperty(
      propertyId,
      propertyData,
    );
    await _localDataSource.cacheProperty(updatedModel);
    return updatedModel;
  }

  @override
  Future<void> deleteProperty(String propertyId) async {
    await _remoteDataSource.deleteProperty(propertyId);
    await _localDataSource.deleteProperty(propertyId);
  }
}
