import '../../domain/entities/bid.dart';

class BidModel extends Bid {
  const BidModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.bidderId,
    super.bidderName,
    super.bidderEmail,
    super.bidderPhone,
    super.bidderAvatarUrl,
    super.bidderBio,
    required super.propertyId,
    super.isVerified,
    super.bidderFaydaStatus,
    super.bankStatementUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      bidderId: json['bidderId'] as String,
      bidderName: json['bidder']?['user']?['name'] as String?,
      bidderEmail: json['bidder']?['user']?['email'] as String?,
      bidderPhone: json['bidder']?['user']?['phone'] as String?,
      bidderAvatarUrl: json['bidder']?['user']?['avatarUrl'] as String?,
      bidderBio: json['bidder']?['user']?['bio'] as String?,
      isVerified: json['bidder']?['user']?['isVerified'] as bool? ?? false,
      bidderFaydaStatus: json['bidder']?['user']?['faydaStatus'] as String?,
      propertyId: json['propertyId'] as String,
      bankStatementUrl: (json['bankStatementUrl'] ?? json['bankStatement']) as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'status': status,
      'bidderId': bidderId,
      'propertyId': propertyId,
      'bankStatement': bankStatementUrl,
      'bidderPhone': bidderPhone,
      'bidderAvatarUrl': bidderAvatarUrl,
      'bidderBio': bidderBio,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
