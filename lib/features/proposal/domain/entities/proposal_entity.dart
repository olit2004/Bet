class ProposalEntity {
  final String id;
  final String propertyId;
  final String buyerId;
  final String status; // PENDING, UNDER_REVIEW, ACCEPTED, REJECTED
  final String? proposalFileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProposalEntity({
    required this.id,
    required this.propertyId,
    required this.buyerId,
    required this.status,
    this.proposalFileUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
