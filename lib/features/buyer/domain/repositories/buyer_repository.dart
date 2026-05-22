import '../entities/buyer_profile.dart';
import '../entities/buyer_dashboard.dart';

abstract class BuyerRepository {
  Future<BuyerProfile> registerAsBuyer();
  Future<BuyerProfile> getProfile();
  Future<BuyerProfile> updateProfile({
    String? email,
    String? name,
    String? phone,
    double? budget,
    String? preferredPropertyType,
    List<String>? preferredLocations,
  });
  Future<BuyerProfile> verifyFayda({
    required String faydaId,
    String? imagePath,
    List<int>? imageBytes,
    String? fileName,
  });
  Future<BuyerDashboard> getDashboard();
}
