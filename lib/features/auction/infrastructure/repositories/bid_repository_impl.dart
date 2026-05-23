import '../../domain/entities/bid_entity.dart';
import '../../domain/repositories/bid_repository.dart';
import '../data_sources/bid_remote_data_source.dart';
import '../data_sources/bid_local_data_source.dart';
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';

class BidRepositoryImpl implements BidRepository {
  final BidRemoteDataSource remoteDataSource;
  final BidLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  BidRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  Future<String> _getToken() async {
    final token = await authLocalDataSource.getToken();
    if (token == null) throw Exception('No authentication token found');
    return token;
  }

  @override
  Future<List<BidEntity>> getPropertyBids(String propertyId) async {
    try {
      final token = await _getToken();
      final remoteBids = await remoteDataSource.getPropertyBids(propertyId, token);
      await localDataSource.cacheBids(remoteBids);
      return remoteBids;
    } catch (e) {
      // Fallback to local cache on error
      final localBids = await localDataSource.getCachedPropertyBids(propertyId);
      if (localBids.isNotEmpty) return localBids;
      throw Exception('Failed to fetch bids and no cache available');
    }
  }

  @override
  Future<BidEntity> placeBid(
    String propertyId,
    double amount, {
    List<int>? bankStatementBytes,
    String? bankStatementFileName,
    String? bankStatementFilePath,
  }) async {
    final token = await _getToken();
    final bid = await remoteDataSource.placeBid(
      propertyId,
      amount,
      token,
      bankStatementBytes: bankStatementBytes,
      bankStatementFileName: bankStatementFileName,
      bankStatementFilePath: bankStatementFilePath,
    );
    await localDataSource.cacheBid(bid);
    return bid;
  }

  @override
  Future<BidEntity> acceptBid(String bidId) async {
    final token = await _getToken();
    final bid = await remoteDataSource.acceptBid(bidId, token);
    await localDataSource.cacheBid(bid);
    return bid;
  }

  @override
  Future<BidEntity> retractBid(String bidId) async {
    final token = await _getToken();
    final bid = await remoteDataSource.retractBid(bidId, token);
    await localDataSource.cacheBid(bid);
    return bid;
  }
}
