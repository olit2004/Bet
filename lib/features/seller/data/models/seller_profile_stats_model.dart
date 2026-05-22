import '../../domain/entities/seller_profile_stats.dart';

class SellerProfileStatsModel extends SellerProfileStats {
  SellerProfileStatsModel({
    required super.activeProperties,
    required super.totalBids,
    required super.totalViews,
    required super.conversionRate,
  });

  factory SellerProfileStatsModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileStatsModel(
      activeProperties: json['activeProperties'] as int? ?? 0,
      totalBids: json['totalBids'] as int? ?? 0,
      totalViews: json['totalViews'] as int? ?? 0,
      conversionRate: json['conversionRate'] as String? ?? '0.0%',
    );
  }
}
