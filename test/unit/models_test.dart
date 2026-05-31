// Unit Tests: Domain Models
//
// Tests the pure data classes (User, Property, Bid, AuthFailure) that have
// no external dependencies – no mocking required.
// Each test verifies a single function / method / computed property.

import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/auth/domain/failures/auth_failure.dart';
import 'package:bet/features/auction/domain/models/bid_model.dart';
import 'package:bet/features/auction/domain/models/auction_model.dart';
import 'package:bet/core/property/models/property_model.dart';

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // User entity
  // ──────────────────────────────────────────────────────────────────────────
  group('User – fromJson', () {
    test('parses all fields from a complete JSON map', () {
      final json = {
        'id': 'u-1',
        'email': 'alice@example.com',
        'role': 'SELLER',
        'name': 'Alice',
        'avatarUrl': 'https://example.com/avatar.png',
        'faydaId': 'FYD-01',
        'faydaImageUrl': 'https://example.com/fayda.png',
        'faydaStatus': 'APPROVED',
        'isVerified': true,
        'createdAt': '2024-03-01T08:00:00.000Z',
        'bio': 'Real estate enthusiast.',
      };

      final user = User.fromJson(json);

      expect(user.id, 'u-1');
      expect(user.email, 'alice@example.com');
      expect(user.role, 'SELLER');
      expect(user.name, 'Alice');
      expect(user.avatarUrl, 'https://example.com/avatar.png');
      expect(user.faydaId, 'FYD-01');
      expect(user.faydaImageUrl, 'https://example.com/fayda.png');
      expect(user.faydaStatus, 'APPROVED');
      expect(user.isVerified, isTrue);
      expect(user.createdAt, DateTime.parse('2024-03-01T08:00:00.000Z'));
      expect(user.bio, 'Real estate enthusiast.');
    });

    test('defaults isVerified to false when field is absent', () {
      final user = User.fromJson({
        'id': 'u-2',
        'email': 'bob@example.com',
        'role': 'BUYER',
      });
      expect(user.isVerified, isFalse);
    });

    test('returns null for optional fields that are absent', () {
      final user = User.fromJson({
        'id': 'u-3',
        'email': 'carol@example.com',
        'role': 'GUEST',
      });
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.faydaId, isNull);
      expect(user.faydaImageUrl, isNull);
      expect(user.faydaStatus, isNull);
      expect(user.createdAt, isNull);
      expect(user.bio, isNull);
    });

    test('handles explicit null createdAt in JSON', () {
      final user = User.fromJson({
        'id': 'u-4',
        'email': 'd@example.com',
        'role': 'BUYER',
        'createdAt': null,
      });
      expect(user.createdAt, isNull);
    });

    test('isVerified is false when explicitly set to false', () {
      final user = User.fromJson({
        'id': 'u-5',
        'email': 'e@example.com',
        'role': 'BUYER',
        'isVerified': false,
      });
      expect(user.isVerified, isFalse);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthFailure hierarchy
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthFailure – exception messages', () {
    test('base AuthFailure uses default message', () {
      const failure = AuthFailure();
      expect(failure.message, 'An unexpected authentication error occurred.');
      expect(failure.toString(), 'An unexpected authentication error occurred.');
    });

    test('AuthFailure accepts a custom message', () {
      const failure = AuthFailure('Custom error.');
      expect(failure.message, 'Custom error.');
    });

    test('InvalidCredentialsFailure has correct message', () {
      const failure = InvalidCredentialsFailure();
      expect(failure.message, 'Invalid email or password.');
      expect(failure, isA<AuthFailure>());
    });

    test('UserAlreadyExistsFailure has correct message', () {
      const failure = UserAlreadyExistsFailure();
      expect(failure.message, 'A user with this email already exists.');
      expect(failure, isA<AuthFailure>());
    });

    test('NetworkFailure has correct message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Please check your internet connection.');
      expect(failure, isA<AuthFailure>());
    });

    test('AuthFailure is an Exception', () {
      expect(const AuthFailure(), isA<Exception>());
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Bid model (domain) – toMap / fromMap
  // ──────────────────────────────────────────────────────────────────────────
  group('Bid – toMap / fromMap', () {
    final ts = DateTime(2024, 6, 1, 10, 0, 0);

    test('toMap contains all expected keys', () {
      final bid = Bid(
        id: 'bid-1',
        bidderId: 'user-A',
        amount: 500000.0,
        timestamp: ts,
      );

      final map = bid.toMap();

      expect(map['id'], 'bid-1');
      expect(map['bidderId'], 'user-A');
      expect(map['amount'], 500000.0);
      expect(map['timestamp'], ts.toIso8601String());
    });

    test('fromMap round-trips correctly with toMap output', () {
      final original = Bid(
        id: 'bid-rt',
        bidderId: 'user-B',
        amount: 1200000.0,
        timestamp: ts,
      );

      final reconstructed = Bid.fromMap(original.toMap());

      expect(reconstructed.id, original.id);
      expect(reconstructed.bidderId, original.bidderId);
      expect(reconstructed.amount, original.amount);
      expect(reconstructed.timestamp, original.timestamp);
    });

    test('fromMap coerces integer amount to double', () {
      final map = {
        'id': 'bid-int',
        'bidderId': 'u',
        'amount': 750000, // int
        'timestamp': ts.toIso8601String(),
      };
      final bid = Bid.fromMap(map);
      expect(bid.amount, isA<double>());
      expect(bid.amount, 750000.0);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Auction – currentHighestBidAmount computed property
  // ──────────────────────────────────────────────────────────────────────────
  group('Auction – currentHighestBidAmount', () {
    final now = DateTime(2024, 6, 1);

    Bid makeBid(String id, double amount) => Bid(
          id: id,
          bidderId: 'u',
          amount: amount,
          timestamp: now,
        );

    test('returns startingPrice when bids list is empty', () {
      final auction = Auction(
        id: 'a1',
        propertyId: 'p1',
        startingPrice: 500000.0,
        endTime: now.add(const Duration(days: 1)),
        bids: [],
      );
      expect(auction.currentHighestBidAmount, 500000.0);
    });

    test('returns the single bid amount when there is one bid', () {
      final auction = Auction(
        id: 'a2',
        propertyId: 'p2',
        startingPrice: 400000.0,
        endTime: now.add(const Duration(days: 1)),
        bids: [makeBid('b1', 450000.0)],
      );
      expect(auction.currentHighestBidAmount, 450000.0);
    });

    test('returns the highest amount when multiple bids exist', () {
      final auction = Auction(
        id: 'a3',
        propertyId: 'p3',
        startingPrice: 300000.0,
        endTime: now.add(const Duration(days: 1)),
        bids: [
          makeBid('b1', 310000.0),
          makeBid('b2', 400000.0),
          makeBid('b3', 350000.0),
        ],
      );
      expect(auction.currentHighestBidAmount, 400000.0);
    });

    test('handles bids placed in non-sorted order', () {
      final auction = Auction(
        id: 'a4',
        propertyId: 'p4',
        startingPrice: 100000.0,
        endTime: now.add(const Duration(days: 1)),
        bids: [
          makeBid('b1', 900000.0), // highest first
          makeBid('b2', 500000.0),
          makeBid('b3', 700000.0),
        ],
      );
      expect(auction.currentHighestBidAmount, 900000.0);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Property – fromJson and categoryName
  // ──────────────────────────────────────────────────────────────────────────
  group('Property – fromJson', () {
    Map<String, dynamic> baseJson() => {
          'id': 'prop-1',
          'title': 'Luxury Villa',
          'description': 'A stunning villa',
          'price': 5000000,
          'address': 'Bole, Addis Ababa',
          'imageUrls': [],
          'type': 'SALE',
        };

    test('parses a SALE property with category buy', () {
      final p = Property.fromJson(baseJson());
      expect(p.id, 'prop-1');
      expect(p.title, 'Luxury Villa');
      expect(p.price, 5000000.0);
      expect(p.category, PropertyCategory.buy);
      expect(p.categoryName, 'Buy');
    });

    test('parses a RENT property correctly', () {
      final json = baseJson()..['type'] = 'RENT';
      final p = Property.fromJson(json);
      expect(p.category, PropertyCategory.rent);
      expect(p.categoryName, 'Rent');
    });

    test('parses a COMMERCIAL property correctly', () {
      final json = baseJson()..['type'] = 'COMMERCIAL';
      final p = Property.fromJson(json);
      expect(p.category, PropertyCategory.commercial);
      expect(p.categoryName, 'Commercial');
    });

    test('defaults to buy category when type is unknown', () {
      final json = baseJson()..['type'] = 'UNKNOWN';
      final p = Property.fromJson(json);
      expect(p.category, PropertyCategory.buy);
    });

    test('builds beds spec from beds field', () {
      final json = baseJson()..['beds'] = 4;
      final p = Property.fromJson(json);
      expect(p.specs.any((s) => s.label == 'Beds' && s.value == '4'), isTrue);
    });

    test('builds baths spec from baths field', () {
      final json = baseJson()..['baths'] = 3;
      final p = Property.fromJson(json);
      expect(p.specs.any((s) => s.label == 'Baths' && s.value == '3'), isTrue);
    });

    test('builds sqm spec from sqFootage field', () {
      final json = baseJson()..['sqFootage'] = 250;
      final p = Property.fromJson(json);
      expect(p.specs.any((s) => s.label == 'SQM' && s.value == '250'), isTrue);
    });

    test('isFeatured is true when listingType is AUCTION', () {
      final json = baseJson()..['listingType'] = 'AUCTION';
      final p = Property.fromJson(json);
      expect(p.isFeatured, isTrue);
    });

    test('isFeatured is false for non-AUCTION listingType', () {
      final json = baseJson()..['listingType'] = 'REGULAR';
      final p = Property.fromJson(json);
      expect(p.isFeatured, isFalse);
    });

    test('prefixes local image URLs with base URL', () {
      final json = baseJson()
        ..['imageUrls'] = ['/public/images/photo.jpg', 'https://external.com/img.jpg'];
      final p = Property.fromJson(json);
      expect(p.imageUrls[0], 'http://localhost:8080/public/images/photo.jpg');
      expect(p.imageUrls[1], 'https://external.com/img.jpg');
    });

    test('price is coerced from int to double', () {
      final json = baseJson()..['price'] = 3000000; // int
      final p = Property.fromJson(json);
      expect(p.price, isA<double>());
    });

    test('parses endTime from endTime field', () {
      final json = baseJson()..['endTime'] = '2024-12-01T00:00:00.000Z';
      final p = Property.fromJson(json);
      expect(p.endTime, DateTime.parse('2024-12-01T00:00:00.000Z'));
    });

    test('falls back to endingAt when endTime is null', () {
      final json = baseJson()..['endingAt'] = '2024-11-01T00:00:00.000Z';
      final p = Property.fromJson(json);
      expect(p.endTime, DateTime.parse('2024-11-01T00:00:00.000Z'));
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // PropertySpec
  // ──────────────────────────────────────────────────────────────────────────
  group('PropertySpec', () {
    test('stores label and value correctly', () {
      const spec = PropertySpec(label: 'Beds', value: '3');
      expect(spec.label, 'Beds');
      expect(spec.value, '3');
      expect(spec.icon, isNull);
    });

    test('stores optional icon when provided', () {
      const spec = PropertySpec(label: 'Beds', value: '3', icon: 'bed');
      expect(spec.icon, 'bed');
    });
  });
}
