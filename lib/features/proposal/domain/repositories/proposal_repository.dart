import '../entities/proposal_entity.dart';

abstract class ProposalRepository {
  Future<List<ProposalEntity>> getMyProposals();
  Future<List<ProposalEntity>> getProposalsByProperty(String propertyId);
  Future<ProposalEntity> createProposal(String propertyId, {String? proposalFilePath});
  Future<ProposalEntity> updateProposalStatus(String proposalId, String status);
}
