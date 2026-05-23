import '../../domain/entities/bid_entity.dart';

class BidModel extends BidEntity {
  BidModel({
    required super.id,
    required super.propertyId,
    required super.buyerId,
    required super.amount,
    required super.status,
    super.bankStatementUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['_id'] ?? json['id'] ?? '',
      propertyId: json['property'] ?? json['propertyId'] ?? '',
      buyerId: json['buyer'] ?? json['buyerId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'PENDING',
      bankStatementUrl: (json['bankStatementUrl'] ?? json['bankStatement']) as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'buyerId': buyerId,
      'amount': amount,
      'status': status,
      'bankStatementUrl': bankStatementUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
