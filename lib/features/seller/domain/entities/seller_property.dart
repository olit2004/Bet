import 'bid.dart';
import 'proposal.dart';

class SellerProperty {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? value;
  final String listingType; // FIXED or AUCTION
  final double latitude;
  final double longitude;
  final String location;
  final String type; // SALE or RENT
  final String status; // ACTIVE, ENDED, CLOSED
  final double? sqFootage;
  final int views;
  final int? bidCount;
  final List<Bid>? bids;
  final List<Proposal>? proposals;
  final List<String> imageUrls;
  final DateTime? endTime;
  final String ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SellerProperty({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.value,
    required this.listingType,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.type,
    this.status = 'ACTIVE',
    this.sqFootage,
    this.views = 0,
    this.bidCount,
    this.bids,
    this.proposals,
    required this.imageUrls,
    this.endTime,
    required this.ownerId,
    this.createdAt,
    this.updatedAt,
  });
}
