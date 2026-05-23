class Bid {
  final String id;
  final double amount;
  final String status;
  final String bidderId;
  final String? bidderName;
  final String? bidderEmail;
  final String propertyId;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Bid({
    required this.id,
    required this.amount,
    required this.status,
    required this.bidderId,
    this.bidderName,
    this.bidderEmail,
    required this.propertyId,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
  });
}
