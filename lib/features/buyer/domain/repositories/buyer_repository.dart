import '../entities/buyer_dashboard.dart';

abstract class BuyerRepository {
  Future<BuyerDashboard> getBuyerDashboard();
}
