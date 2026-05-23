
class DashboardPropertyInfo {
  final String id;
  final String title;
  final String status;
  final String location;
  final DateTime? endTime;
  final List<String> imageUrls;
  final String description;

  DashboardPropertyInfo({
    required this.id,
    required this.title,
    required this.status,
    required this.location,
    this.endTime,
    this.imageUrls = const [],
    required this.description,
  });

  factory DashboardPropertyInfo.fromJson(Map<String, dynamic> json) {
    return DashboardPropertyInfo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      endTime: (json['endingAt'] ?? json['endTime']) != null ? DateTime.tryParse((json['endingAt'] ?? json['endTime']) as String) : null,
      imageUrls: json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      description: json['description'] ?? '',
    );
  }
}

class DashboardActionItem {
  final String id;
  final double amount;
  final String status;
  final DateTime createdAt;
  final DashboardPropertyInfo property;
  final bool isBid;

  DashboardActionItem({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.property,
    this.isBid = true,
  });

  factory DashboardActionItem.fromJson(Map<String, dynamic> json, {bool isBid = true}) {
    return DashboardActionItem(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      property: DashboardPropertyInfo.fromJson(json['property'] ?? {}),
      isBid: isBid,
    );
  }
}

class DashboardStatistics {
  final int totalBids;
  final int activeBids;
  final int acceptedBids;
  final int totalProposals;
  final int pendingProposals;
  final int acceptedProposals;

  DashboardStatistics({
    required this.totalBids,
    required this.activeBids,
    required this.acceptedBids,
    required this.totalProposals,
    required this.pendingProposals,
    required this.acceptedProposals,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalBids: json['totalBids'] ?? 0,
      activeBids: json['activeBids'] ?? 0,
      acceptedBids: json['acceptedBids'] ?? 0,
      totalProposals: json['totalProposals'] ?? 0,
      pendingProposals: json['pendingProposals'] ?? 0,
      acceptedProposals: json['acceptedProposals'] ?? 0,
    );
  }
}

class BuyerDashboard {
  final DashboardStatistics statistics;
  final List<DashboardActionItem> recentBids;
  final List<DashboardActionItem> recentProposals;

  BuyerDashboard({
    required this.statistics,
    required this.recentBids,
    required this.recentProposals,
  });

  factory BuyerDashboard.fromJson(Map<String, dynamic> json) {
    return BuyerDashboard(
      statistics: DashboardStatistics.fromJson(json['statistics'] ?? {}),
      recentBids: (json['recentBids'] as List<dynamic>?)
              ?.map((e) => DashboardActionItem.fromJson(e, isBid: true))
              .toList() ??
          [],
      recentProposals: (json['recentProposals'] as List<dynamic>?)
              ?.map((e) => DashboardActionItem.fromJson(e, isBid: false))
              .toList() ??
          [],
    );
  }
}
