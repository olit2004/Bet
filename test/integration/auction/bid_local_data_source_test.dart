// Integration test: BidLocalDataSourceImpl + DatabaseHelper
//
// Runs a real SQLite database in-process using sqflite_common_ffi so that the
// INSERT / SELECT / batch operations of BidLocalDataSourceImpl are exercised
// against an actual DB engine rather than a mock.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:bet/core/database/database_helper.dart';
import 'package:bet/features/auction/infrastructure/data_sources/bid_local_data_source.dart';
import 'package:bet/features/auction/infrastructure/models/bid_model.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Build an isolated, in-memory DatabaseHelper for testing.
/// We reset the singleton state so each test gets a clean database.
Future<DatabaseHelper> _freshDatabaseHelper() async {
  // Reset the singleton's cached Database so a new one is opened
  // (sqflite_common_ffi allows opening the same path multiple times in tests).
  final helper = DatabaseHelper();
  // Access the database getter to force initialisation
  await helper.database;
  // Clear all tables so tests are independent
  await helper.clearDatabase();
  return helper;
}

BidModel _makeBid({
  required String id,
  required String propertyId,
  String buyerId = 'buyer-1',
  double amount = 100000.0,
  String status = 'PENDING',
}) {
  final now = DateTime(2024, 1, 1);
  return BidModel(
    id: id,
    propertyId: propertyId,
    buyerId: buyerId,
    amount: amount,
    status: status,
    createdAt: now,
    updatedAt: now,
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // Initialise sqflite_common_ffi so the tests can run without Flutter or a
  // device. Must be called before any database access.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('BidLocalDataSourceImpl – cacheBid / getCachedPropertyBids', () {
    test('cached bid is retrievable by propertyId', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      final bid = _makeBid(id: 'b1', propertyId: 'prop-A');
      await ds.cacheBid(bid);

      final results = await ds.getCachedPropertyBids('prop-A');
      expect(results.length, 1);
      expect(results.first.id, 'b1');
      expect(results.first.propertyId, 'prop-A');
      expect(results.first.amount, 100000.0);
    });

    test('caching the same bid id twice replaces (upsert) the old record', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      final original = _makeBid(id: 'b2', propertyId: 'prop-B', amount: 200000.0);
      await ds.cacheBid(original);

      final updated = _makeBid(id: 'b2', propertyId: 'prop-B', amount: 250000.0);
      await ds.cacheBid(updated);

      final results = await ds.getCachedPropertyBids('prop-B');
      expect(results.length, 1);
      expect(results.first.amount, 250000.0);
    });

    test('bids for different properties are isolated correctly', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      await ds.cacheBid(_makeBid(id: 'bX', propertyId: 'prop-X'));
      await ds.cacheBid(_makeBid(id: 'bY', propertyId: 'prop-Y'));

      final xBids = await ds.getCachedPropertyBids('prop-X');
      final yBids = await ds.getCachedPropertyBids('prop-Y');

      expect(xBids.length, 1);
      expect(yBids.length, 1);
      expect(xBids.first.id, 'bX');
      expect(yBids.first.id, 'bY');
    });

    test('returns empty list when no bids match the propertyId', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      final results = await ds.getCachedPropertyBids('non-existent-prop');
      expect(results, isEmpty);
    });
  });

  group('BidLocalDataSourceImpl – cacheBids (batch)', () {
    test('cacheBids stores multiple bids in a single operation', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      final bids = [
        _makeBid(id: 'batch-1', propertyId: 'prop-C', amount: 110000.0),
        _makeBid(id: 'batch-2', propertyId: 'prop-C', amount: 120000.0),
        _makeBid(id: 'batch-3', propertyId: 'prop-C', amount: 130000.0),
      ];

      await ds.cacheBids(bids);

      final results = await ds.getCachedPropertyBids('prop-C');
      expect(results.length, 3);
      final ids = results.map((b) => b.id).toSet();
      expect(ids, containsAll(['batch-1', 'batch-2', 'batch-3']));
    });

    test('cacheBids with empty list does not throw', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      await expectLater(ds.cacheBids([]), completes);
    });
  });

  group('BidLocalDataSourceImpl – clearBids', () {
    test('clearBids removes all cached bid records', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      await ds.cacheBid(_makeBid(id: 'del-1', propertyId: 'prop-D'));
      await ds.cacheBid(_makeBid(id: 'del-2', propertyId: 'prop-D'));

      await ds.clearBids();

      final results = await ds.getCachedPropertyBids('prop-D');
      expect(results, isEmpty);
    });
  });

  group('DatabaseHelper – clearDatabase', () {
    test('clearDatabase empties all tables without error', () async {
      final dbHelper = await _freshDatabaseHelper();
      final ds = BidLocalDataSourceImpl(dbHelper);

      await ds.cacheBid(_makeBid(id: 'clr-1', propertyId: 'prop-E'));
      await dbHelper.clearDatabase();

      final results = await ds.getCachedPropertyBids('prop-E');
      expect(results, isEmpty);
    });
  });
}
