class Proposal {
  final String id;
  final String propertyId;
  final String bidderId;
  final String? bidderName;
  final String? bidderEmail;
  final String? bidderPhone;
  final String? bidderAvatarUrl;
  final String? bidderBio;
  final double? amount;
  final String details;
  final String? fileUrl;
  final String status;
  final bool isVerified;
  final String? bidderFaydaStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Proposal({
    required this.id,
    required this.propertyId,
    required this.bidderId,
    this.bidderName,
    this.bidderEmail,
    this.bidderPhone,
    this.bidderAvatarUrl,
    this.bidderBio,
    this.amount,
    required this.details,
    this.fileUrl,
    required this.status,
    this.isVerified = false,
    this.bidderFaydaStatus,
    this.createdAt,
    this.updatedAt,
  });
}
