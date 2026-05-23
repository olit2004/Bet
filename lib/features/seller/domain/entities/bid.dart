class Bid {
  final String id;
  final double amount;
  final String status;
  final String bidderId;
  final String? bidderName;
  final String? bidderEmail;
  final String? bidderPhone;
  final String? bidderAvatarUrl;
  final String? bidderBio;
  final String propertyId;
  final bool isVerified;
  final String? bidderFaydaStatus;
  final String? bankStatementUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Bid({
    required this.id,
    required this.amount,
    required this.status,
    required this.bidderId,
    this.bidderName,
    this.bidderEmail,
    this.bidderPhone,
    this.bidderAvatarUrl,
    this.bidderBio,
    required this.propertyId,
    this.isVerified = false,
    this.bidderFaydaStatus,
    this.bankStatementUrl,
    this.createdAt,
    this.updatedAt,
  });
}
