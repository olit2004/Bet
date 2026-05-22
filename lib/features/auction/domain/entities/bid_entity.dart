class BidEntity {
  final String id;
  final String propertyId;
  final String buyerId;
  final double amount;
  final String status; // e.g. PENDING, ACCEPTED, RETRACTED
  final String? bankStatementUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BidEntity({
    required this.id,
    required this.propertyId,
    required this.buyerId,
    required this.amount,
    required this.status,
    this.bankStatementUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
