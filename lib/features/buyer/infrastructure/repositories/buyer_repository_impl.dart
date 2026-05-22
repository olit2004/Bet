import '../../domain/entities/buyer_profile.dart';
import '../../domain/entities/buyer_dashboard.dart';
import '../../domain/repositories/buyer_repository.dart';
import '../data_sources/buyer_remote_data_source.dart';

class BuyerRepositoryImpl implements BuyerRepository {
  final BuyerRemoteDataSource _remoteDataSource;

  BuyerRepositoryImpl({BuyerRemoteDataSource? remoteDataSource}) 
      : _remoteDataSource = remoteDataSource ?? BuyerRemoteDataSource();

  @override
  Future<BuyerProfile> registerAsBuyer() {
    return _remoteDataSource.registerAsBuyer();
  }

  @override
  Future<BuyerProfile> getProfile() {
    return _remoteDataSource.getProfile();
  }

  @override
  Future<BuyerProfile> updateProfile({
    String? email,
    String? name,
    String? phone,
    double? budget,
    String? preferredPropertyType,
    List<String>? preferredLocations,
  }) {
    return _remoteDataSource.updateProfile(
      email: email,
      name: name,
      phone: phone,
      budget: budget,
      preferredPropertyType: preferredPropertyType,
      preferredLocations: preferredLocations,
    );
  }

  @override
  Future<BuyerProfile> verifyFayda({
    required String faydaId,
    String? imagePath,
    List<int>? imageBytes,
    String? fileName,
  }) {
    return _remoteDataSource.verifyFayda(
      faydaId: faydaId,
      imagePath: imagePath,
      imageBytes: imageBytes,
      fileName: fileName,
    );
  }

  @override
  Future<BuyerDashboard> getDashboard() {
    return _remoteDataSource.getDashboard();
  }
}
