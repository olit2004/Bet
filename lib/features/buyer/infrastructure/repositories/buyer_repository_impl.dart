import '../../domain/entities/buyer_dashboard.dart';
import '../../domain/repositories/buyer_repository.dart';
import '../data_sources/buyer_remote_data_source.dart';
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';

class BuyerRepositoryImpl implements BuyerRepository {
  final BuyerRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  BuyerRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<BuyerDashboard> getBuyerDashboard() async {
    final token = await authLocalDataSource.getToken();
    if (token == null) {
      throw Exception('User is not authenticated');
    }
    return await remoteDataSource.getBuyerDashboard(token);
  }
}
