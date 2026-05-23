import '../../domain/entities/proposal.dart';

class ProposalModel extends Proposal {
  const ProposalModel({
    required super.id,
    required super.propertyId,
    required super.bidderId,
    super.bidderName,
    super.bidderEmail,
    super.bidderPhone,
    super.bidderAvatarUrl,
    super.bidderBio,
    super.amount,
    required super.details,
    super.fileUrl,
    required super.status,
    super.isVerified,
    super.bidderFaydaStatus,
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
      bidderPhone: json['bidder']?['user']?['phone'] as String?,
      bidderAvatarUrl: json['bidder']?['user']?['avatarUrl'] as String?,
      bidderBio: json['bidder']?['user']?['bio'] as String?,
      isVerified: json['bidder']?['user']?['isVerified'] as bool? ?? false,
      bidderFaydaStatus: json['bidder']?['user']?['faydaStatus'] as String?,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      details: json['details'] as String,
      fileUrl: json['fileUrl'] as String?,
      status: json['status'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'bidderId': bidderId,
      'bidder': {
        'user': {
          'name': bidderName,
          'email': bidderEmail,
          'isVerified': isVerified,
        }
      },
      if (amount != null) 'amount': amount,
      'details': details,
      if (fileUrl != null) 'fileUrl': fileUrl,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
