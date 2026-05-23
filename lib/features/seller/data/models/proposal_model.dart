import '../../domain/entities/proposal.dart';

class ProposalModel extends Proposal {
  const ProposalModel({
    required super.id,
    required super.propertyId,
    required super.bidderId,
    super.bidderName,
    super.bidderEmail,
    super.amount,
    required super.details,
    super.fileUrl,
    required super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      bidderId: json['bidderId'] as String,
      bidderName: json['bidder']?['user']?['name'] as String?,
      bidderEmail: json['bidder']?['user']?['email'] as String?,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      details: json['details'] as String,
      fileUrl: json['fileUrl'] as String?,
      status: json['status'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
}
