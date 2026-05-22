import '../../domain/entities/seller_profile_stats.dart';
import '../../domain/repositories/seller_profile_repository.dart';
import '../data_sources/seller_profile_remote_data_source.dart';

class SellerProfileRepositoryImpl implements SellerProfileRepository {
  final SellerProfileRemoteDataSource _remoteDataSource;

  SellerProfileRepositoryImpl({
    required SellerProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<SellerProfileStats> getSellerStats(String sellerId) async {
    return await _remoteDataSource.getSellerStats(sellerId);
  }
}
