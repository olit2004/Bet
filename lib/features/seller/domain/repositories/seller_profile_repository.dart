import '../entities/seller_profile_stats.dart';

abstract class SellerProfileRepository {
  Future<SellerProfileStats> getSellerStats(String sellerId);
}
