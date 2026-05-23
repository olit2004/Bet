import '../../domain/entities/proposal_entity.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../data_sources/proposal_remote_data_source.dart';
import '../data_sources/proposal_local_data_source.dart';
import '../../../auth/infrastructure/data_sources/auth_local_data_source.dart';

class ProposalRepositoryImpl implements ProposalRepository {
  final ProposalRemoteDataSource remoteDataSource;
  final ProposalLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  ProposalRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  });

  Future<String> _getToken() async {
    final token = await authLocalDataSource.getToken();
    if (token == null) throw Exception('No authentication token found');
    return token;
  }

  @override
  Future<List<ProposalEntity>> getMyProposals() async {
    try {
      final token = await _getToken();
      final remoteProposals = await remoteDataSource.getMyProposals(token);
      await localDataSource.cacheProposals(remoteProposals);
      return remoteProposals;
    } catch (e) {
      // For a real app, you'd need the buyerId to fetch from cache properly.
      // But we can just return an empty list or throw here.
      throw Exception('Failed to fetch proposals and no cache available');
    }
  }

  @override
  Future<List<ProposalEntity>> getProposalsByProperty(String propertyId) async {
    try {
      final token = await _getToken();
      final remoteProposals = await remoteDataSource.getProposalsByProperty(propertyId, token);
      await localDataSource.cacheProposals(remoteProposals);
      return remoteProposals;
    } catch (e) {
      final localProposals = await localDataSource.getCachedPropertyProposals(propertyId);
      if (localProposals.isNotEmpty) return localProposals;
      throw Exception('Failed to fetch property proposals and no cache available');
    }
  }

  @override
  Future<ProposalEntity> createProposal(String propertyId, {String? proposalFilePath, List<int>? fileBytes, String? fileName, double? amount, String? details}) async {
    final token = await _getToken();
    final proposal = await remoteDataSource.createProposal(propertyId, token, proposalFilePath: proposalFilePath, fileBytes: fileBytes, fileName: fileName, amount: amount, details: details);
    await localDataSource.cacheProposal(proposal);
    return proposal;
  }

  @override
  Future<ProposalEntity> updateProposalStatus(String proposalId, String status) async {
    final token = await _getToken();
    final proposal = await remoteDataSource.updateProposalStatus(proposalId, status, token);
    await localDataSource.cacheProposal(proposal);
    return proposal;
  }
}
