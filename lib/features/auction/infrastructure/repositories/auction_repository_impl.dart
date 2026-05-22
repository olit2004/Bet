import 'dart:async';
import '../../domain/models/auction_model.dart';
import '../../domain/models/bid_model.dart';
import '../../domain/repositories/auction_repository.dart';



// mock implementation of the auction repostory taht controllers communication of the data base 

class MockAuctionRepositoryImpl implements AuctionRepository {
  
  final List<Auction> _fakeDatabase = [

    Auction(
      id: 'auction_1',
      propertyId: 'prop_1',
      startingPrice: 500000.0,
      endTime: DateTime.now().add(const Duration(hours: 24)),
      status: AuctionStatus.active,
      bids: [
        Bid(
          id: 'bid_1',
          bidderId: 'user_A',
          amount: 510000.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ],
    ),

    Auction(
      id: 'auction_2',
      propertyId: 'prop_2',
      startingPrice: 1200000.0,
      endTime: DateTime.now().add(const Duration(days: 3)), 
      status: AuctionStatus.active,
      bids: [], 
    ),
  ];


  final StreamController<Auction> _streamController = StreamController<Auction>.broadcast();

  

  @override
  Future<List<Auction>> getActiveAuctions() async {
  
    await Future.delayed(const Duration(seconds: 1));
    
   
    return _fakeDatabase.where((auction) => auction.status == AuctionStatus.active).toList();
  }

  @override
  Future<Auction?> getAuctionById(String auctionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {

      return _fakeDatabase.firstWhere((auction) => auction.id == auctionId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> placeBid(String auctionId, Bid bid) async {
    await Future.delayed(const Duration(milliseconds: 500)); 

    final auctionIndex = _fakeDatabase.indexWhere((a) => a.id == auctionId);
    if (auctionIndex == -1) return; 

    final oldAuction = _fakeDatabase[auctionIndex];

   
    final updatedBids = List<Bid>.from(oldAuction.bids)..add(bid);
    
    final updatedAuction = Auction(
      id: oldAuction.id,
      propertyId: oldAuction.propertyId,
      startingPrice: oldAuction.startingPrice,
      endTime: oldAuction.endTime,
      status: oldAuction.status,
      bids: updatedBids,
    );

    
    _fakeDatabase[auctionIndex] = updatedAuction;

    
    _streamController.add(updatedAuction);
  }

  @override
  Stream<Auction> watchAuction(String auctionId) {
    return _streamController.stream.where((auction) => auction.id == auctionId);
  }
}
