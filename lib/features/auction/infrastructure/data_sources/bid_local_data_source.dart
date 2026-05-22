import '../../../../core/database/database_helper.dart';
import '../models/bid_model.dart';

abstract class BidLocalDataSource {
  Future<void> cacheBids(List<BidModel> bids);
  Future<List<BidModel>> getCachedPropertyBids(String propertyId);
  Future<void> cacheBid(BidModel bid);
  Future<void> clearBids();
}

class BidLocalDataSourceImpl implements BidLocalDataSource {
  final DatabaseHelper databaseHelper;

  BidLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> cacheBids(List<BidModel> bids) async {
    final db = await databaseHelper.database;
    final batch = db.batch();
    for (var bid in bids) {
      batch.insert(
        'bids',
        bid.toJson(),
        conflictAlgorithm: 5, // CONFLICT_REPLACE
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<BidModel>> getCachedPropertyBids(String propertyId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bids',
      where: 'propertyId = ?',
      whereArgs: [propertyId],
    );
    return maps.map((json) => BidModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheBid(BidModel bid) async {
    final db = await databaseHelper.database;
    await db.insert(
      'bids',
      bid.toJson(),
      conflictAlgorithm: 5, // CONFLICT_REPLACE
    );
  }

  @override
  Future<void> clearBids() async {
    final db = await databaseHelper.database;
    await db.delete('bids');
  }
}
