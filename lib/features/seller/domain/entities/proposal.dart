class Proposal {
  final String id;
  final String propertyId;
  final String bidderId;
  final String? bidderName;
  final String? bidderEmail;
  final double? amount;
  final String details;
  final String? fileUrl;
  final String status;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Proposal({
    required this.id,
    required this.propertyId,
    required this.bidderId,
    this.bidderName,
    this.bidderEmail,
    this.amount,
    required this.details,
    this.fileUrl,
    required this.status,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });
}
