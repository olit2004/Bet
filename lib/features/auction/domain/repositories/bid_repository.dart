import '../entities/bid_entity.dart';

abstract class BidRepository {
  Future<List<BidEntity>> getPropertyBids(String propertyId);
  Future<BidEntity> placeBid(String propertyId, double amount, {String? bankStatementPath});
  Future<BidEntity> acceptBid(String bidId);
  Future<BidEntity> retractBid(String bidId);
}
