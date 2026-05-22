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
}
