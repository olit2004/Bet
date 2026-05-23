import '../../domain/entities/seller_property.dart';
import 'bid_model.dart';
import 'proposal_model.dart';

class SellerPropertyModel extends SellerProperty {
  const SellerPropertyModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    super.value,
    required super.listingType,
    required super.latitude,
    required super.longitude,
    required super.location,
    required super.type,
    super.status,
    super.sqFootage,
    super.views,
    super.bidCount,
    super.bids,
    super.proposals,
    required super.imageUrls,
    super.endTime,
    required super.ownerId,
    super.createdAt,
    super.updatedAt,
  });

  factory SellerPropertyModel.fromJson(Map<String, dynamic> json) {
    return SellerPropertyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      value: json['value'] != null ? (json['value'] as num).toDouble() : null,
      listingType: json['listingType'] as String? ?? 'FIXED',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      location: json['location'] as String? ?? 'Unknown',
      type: json['type'] as String,
      status: json['status'] as String? ?? 'ACTIVE',
      sqFootage: json['sqFootage'] != null
          ? (json['sqFootage'] as num).toDouble()
          : null,
      views: json['views'] as int? ?? 0,
      bidCount: json['_count'] != null
          ? (json['_count'] as Map<String, dynamic>)['bids'] as int?
          : null,
      bids: json['bids'] != null
          ? (json['bids'] as List)
              .map((e) => BidModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      proposals: json['proposals'] != null
          ? (json['proposals'] as List)
              .map((e) => ProposalModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'] as List)
          : [],
      endTime: (json['endingAt'] ?? json['endTime']) != null
          ? DateTime.parse((json['endingAt'] ?? json['endTime']) as String)
          : null,
      ownerId: json['ownerId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      if (value != null) 'value': value,
      'listingType': listingType,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'type': type,
      'status': status,
      if (sqFootage != null) 'sqFootage': sqFootage,
      'imageUrls': imageUrls,
      if (endTime != null) 'endTime': endTime?.toIso8601String(),
    };
  }
}
