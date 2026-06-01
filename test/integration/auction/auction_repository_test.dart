// Integration test: MockAuctionRepositoryImpl
//
// Exercises the in-memory auction repository that backs the auction feature.
// Tests cover: listing active auctions, fetching by ID, placing bids,
// the currentHighestBidAmount computed property, and the watchAuction stream.

import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auction/domain/models/auction_model.dart';
import 'package:bet/features/auction/domain/models/bid_model.dart';
import 'package:bet/features/auction/infrastructure/repositories/auction_repository_impl.dart';

void main() {
  late MockAuctionRepositoryImpl repo;

  setUp(() {
    repo = MockAuctionRepositoryImpl();
  });

  group('MockAuctionRepositoryImpl – getActiveAuctions', () {
    test('returns only active auctions', () async {
      final auctions = await repo.getActiveAuctions();

      expect(auctions, isNotEmpty);
      expect(
        auctions.every((a) => a.status == AuctionStatus.active),
        isTrue,
      );
    });

    test('pre-seeded data contains 2 active auctions', () async {
      final auctions = await repo.getActiveAuctions();
      expect(auctions.length, 2);
    });
  });

  group('MockAuctionRepositoryImpl – getAuctionById', () {
    test('returns the correct auction for a known ID', () async {
      final auction = await repo.getAuctionById('auction_1');

      expect(auction, isNotNull);
      expect(auction!.id, 'auction_1');
      expect(auction.propertyId, 'prop_1');
      expect(auction.startingPrice, 500000.0);
    });

    test('returns null for an unknown ID', () async {
      final auction = await repo.getAuctionById('no-such-auction');
      expect(auction, isNull);
    });
  });

  group('Auction – currentHighestBidAmount', () {
    test('returns startingPrice when there are no bids', () async {
      final auction = await repo.getAuctionById('auction_2');
      expect(auction, isNotNull);
      expect(auction!.bids, isEmpty);
      expect(auction.currentHighestBidAmount, auction.startingPrice);
    });

    test('returns the highest bid amount when bids exist', () async {
      final auction = await repo.getAuctionById('auction_1');
      expect(auction, isNotNull);
      // auction_1 is seeded with one bid of 510000
      expect(auction!.currentHighestBidAmount, 510000.0);
    });
  });

  group('MockAuctionRepositoryImpl – placeBid', () {
    test('adding a bid increases the bid count', () async {
      final newBid = Bid(
        id: 'bid-new-1',
        bidderId: 'user-B',
        amount: 520000.0,
        timestamp: DateTime.now(),
      );

      await repo.placeBid('auction_1', newBid);

      final updated = await repo.getAuctionById('auction_1');
      expect(updated!.bids.length, 2); // was 1, now 2
    });

    test('currentHighestBidAmount updates after a higher bid is placed', () async {
      final newBid = Bid(
        id: 'bid-new-2',
        bidderId: 'user-C',
        amount: 620000.0,
        timestamp: DateTime.now(),
      );

      await repo.placeBid('auction_1', newBid);

      final updated = await repo.getAuctionById('auction_1');
      expect(updated!.currentHighestBidAmount, 620000.0);
    });

    test('placeBid on unknown auction ID does nothing (no error)', () async {
      final bid = Bid(
        id: 'bid-ghost',
        bidderId: 'u',
        amount: 1000.0,
        timestamp: DateTime.now(),
      );
      // Should complete without throwing
      await expectLater(
        repo.placeBid('unknown-auction', bid),
        completes,
      );
    });
  });

  group('MockAuctionRepositoryImpl – watchAuction (stream)', () {
    test('stream emits the updated auction after placeBid', () async {
      final newBid = Bid(
        id: 'bid-stream-1',
        bidderId: 'user-D',
        amount: 515000.0,
        timestamp: DateTime.now(),
      );

      // Start listening before placing the bid
      final streamFuture = repo.watchAuction('auction_1').first;

      await repo.placeBid('auction_1', newBid);

      final emitted = await streamFuture;
      expect(emitted.id, 'auction_1');
      expect(emitted.bids.any((b) => b.id == 'bid-stream-1'), isTrue);
    });

    test('stream only emits events for the watched auction ID', () async {
      final events = <Auction>[];
      final subscription = repo.watchAuction('auction_2').listen(events.add);

      // Place a bid on auction_1 — should NOT appear in auction_2 stream
      await repo.placeBid('auction_1', Bid(
        id: 'b-other',
        bidderId: 'u',
        amount: 510001.0,
        timestamp: DateTime.now(),
      ));

      // Small delay to let any spurious events arrive
      await Future.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(events, isEmpty);
    });
  });
}
