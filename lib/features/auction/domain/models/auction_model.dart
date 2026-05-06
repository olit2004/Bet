import 'bid_model.dart';


enum AuctionStatus { active, completed, cancelled }

// an object reperesenting single auction 

class Auction {

  final String id;

  final String propertyId;
  final double startingPrice;
  final List<Bid> bids;
  final DateTime endTime;
  final AuctionStatus status;

  const Auction({
    required this.id,
    required this.propertyId,
    required this.startingPrice,
    this.bids = const [], 
    required this.endTime,
    this.status = AuctionStatus.active, 
  });
  
  double get currentHighestBidAmount {
    if (bids.isEmpty) {
      return startingPrice;
    }

    final sortedBids = bids.toList()..sort((a, b) => a.amount.compareTo(b.amount));
    return sortedBids.last.amount;
  }
}
