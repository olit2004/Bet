import '../../domain/entities/proposal_entity.dart';

class ProposalModel extends ProposalEntity {
  ProposalModel({
    required super.id,
    required super.propertyId,
    required super.buyerId,
    required super.status,
    super.proposalFileUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['_id'] ?? json['id'] ?? '',
      propertyId: json['property'] ?? json['propertyId'] ?? '',
      buyerId: json['buyer'] ?? json['buyerId'] ?? '',
      status: json['status'] ?? 'PENDING',
      proposalFileUrl: json['proposalFile'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'buyerId': buyerId,
      'status': status,
      'proposalFileUrl': proposalFileUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
