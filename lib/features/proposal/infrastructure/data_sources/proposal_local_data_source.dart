import '../../../../core/database/database_helper.dart';
import '../models/proposal_model.dart';

abstract class ProposalLocalDataSource {
  Future<void> cacheProposals(List<ProposalModel> proposals);
  Future<List<ProposalModel>> getCachedMyProposals(String buyerId);
  Future<List<ProposalModel>> getCachedPropertyProposals(String propertyId);
  Future<void> cacheProposal(ProposalModel proposal);
  Future<void> clearProposals();
}

class ProposalLocalDataSourceImpl implements ProposalLocalDataSource {
  final DatabaseHelper databaseHelper;

  ProposalLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<void> cacheProposals(List<ProposalModel> proposals) async {
    final db = await databaseHelper.database;
    final batch = db.batch();
    for (var proposal in proposals) {
      batch.insert(
        'proposals',
        proposal.toJson(),
        conflictAlgorithm: 5, // CONFLICT_REPLACE
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ProposalModel>> getCachedMyProposals(String buyerId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'proposals',
      where: 'buyerId = ?',
      whereArgs: [buyerId],
    );
    return maps.map((json) => ProposalModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProposalModel>> getCachedPropertyProposals(String propertyId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'proposals',
      where: 'propertyId = ?',
      whereArgs: [propertyId],
    );
    return maps.map((json) => ProposalModel.fromJson(json)).toList();
  }

  @override
  Future<void> cacheProposal(ProposalModel proposal) async {
    final db = await databaseHelper.database;
    await db.insert(
      'proposals',
      proposal.toJson(),
      conflictAlgorithm: 5, // CONFLICT_REPLACE
    );
  }

  @override
  Future<void> clearProposals() async {
    final db = await databaseHelper.database;
    await db.delete('proposals');
  }
}
