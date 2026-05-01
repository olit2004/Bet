import 'auction_model.dart';
import 'bid_model.dart';


abstract class AuctionRepository {
  

  Future<List<Auction>> getActiveAuctions();


  Future<Auction?> getAuctionById(String auctionId);


  Future<void> placeBid(String auctionId, Bid bid);

 
  Stream<Auction> watchAuction(String auctionId);
}
