// Integration test: BidModel
//
// Verifies JSON deserialization (fromJson) and serialization (toJson)
// including both the API field names (_id, property, buyer) and the
// local DB field names (id, propertyId, buyerId).

import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auction/infrastructure/models/bid_model.dart';

void main() {
  // ── Fixtures ────────────────────────────────────────────────────────────────
  final now = DateTime(2024, 6, 1, 12, 0, 0);
  final nowIso = now.toIso8601String();

  group('BidModel.fromJson – API field names (_id, property, buyer)', () {
    test('maps all fields correctly from API response', () {
      final json = {
        '_id': 'bid-api-1',
        'property': 'prop-abc',
        'buyer': 'buyer-xyz',
        'amount': 750000.0,
        'status': 'PENDING',
        'bankStatement': 'https://example.com/stmt.pdf',
        'createdAt': nowIso,
        'updatedAt': nowIso,
      };

      final bid = BidModel.fromJson(json);

      expect(bid.id, 'bid-api-1');
      expect(bid.propertyId, 'prop-abc');
      expect(bid.buyerId, 'buyer-xyz');
      expect(bid.amount, 750000.0);
      expect(bid.status, 'PENDING');
      expect(bid.bankStatementUrl, 'https://example.com/stmt.pdf');
      expect(bid.createdAt, now);
      expect(bid.updatedAt, now);
    });

    test('uses local field names (id, propertyId, buyerId) when _id is absent', () {
      final json = {
        'id': 'bid-local-1',
        'propertyId': 'prop-123',
        'buyerId': 'buyer-456',
        'amount': 500000,
        'status': 'ACCEPTED',
        'createdAt': nowIso,
        'updatedAt': nowIso,
      };

      final bid = BidModel.fromJson(json);

      expect(bid.id, 'bid-local-1');
      expect(bid.propertyId, 'prop-123');
      expect(bid.buyerId, 'buyer-456');
      expect(bid.amount, 500000.0);
      expect(bid.status, 'ACCEPTED');
      expect(bid.bankStatementUrl, isNull);
    });

    test('amount is coerced from int to double', () {
      final json = {
        'id': 'bid-int',
        'propertyId': 'p',
        'buyerId': 'b',
        'amount': 1000000, // int
        'status': 'PENDING',
        'createdAt': nowIso,
        'updatedAt': nowIso,
      };

      final bid = BidModel.fromJson(json);
      expect(bid.amount, isA<double>());
      expect(bid.amount, 1000000.0);
    });

    test('defaults to 0.0 when amount is null', () {
      final json = {
        'id': 'bid-null-amount',
        'propertyId': 'p',
        'buyerId': 'b',
        'amount': null,
        'status': 'PENDING',
        'createdAt': nowIso,
        'updatedAt': nowIso,
      };

      final bid = BidModel.fromJson(json);
      expect(bid.amount, 0.0);
    });

    test('uses DateTime.now() when createdAt / updatedAt are null', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));

      final json = {
        'id': 'bid-no-dates',
        'propertyId': 'p',
        'buyerId': 'b',
        'amount': 100.0,
        'status': 'PENDING',
        'createdAt': null,
        'updatedAt': null,
      };

      final bid = BidModel.fromJson(json);
      final after = DateTime.now().add(const Duration(seconds: 1));

      expect(bid.createdAt.isAfter(before), isTrue);
      expect(bid.createdAt.isBefore(after), isTrue);
    });
  });

  group('BidModel.toJson – serialization', () {
    test('round-trips correctly through fromJson → toJson', () {
      final original = BidModel(
        id: 'bid-rt-1',
        propertyId: 'prop-rt',
        buyerId: 'buyer-rt',
        amount: 999999.99,
        status: 'RETRACTED',
        bankStatementUrl: null,
        createdAt: now,
        updatedAt: now,
      );

      final json = original.toJson();
      final reconstructed = BidModel.fromJson(json);

      expect(reconstructed.id, original.id);
      expect(reconstructed.propertyId, original.propertyId);
      expect(reconstructed.buyerId, original.buyerId);
      expect(reconstructed.amount, original.amount);
      expect(reconstructed.status, original.status);
      expect(reconstructed.bankStatementUrl, isNull);
      expect(reconstructed.createdAt, original.createdAt);
      expect(reconstructed.updatedAt, original.updatedAt);
    });

    test('toJson contains all expected keys', () {
      final bid = BidModel(
        id: 'b1',
        propertyId: 'p1',
        buyerId: 'u1',
        amount: 100.0,
        status: 'PENDING',
        createdAt: now,
        updatedAt: now,
      );

      final json = bid.toJson();

      expect(json.keys, containsAll(['id', 'propertyId', 'buyerId', 'amount', 'status', 'createdAt', 'updatedAt']));
    });
  });
}
