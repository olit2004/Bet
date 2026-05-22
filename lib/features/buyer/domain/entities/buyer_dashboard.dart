class BuyerDashboard {
  final int totalBids;
  final int activeBids;
  final int acceptedBids;
  final int totalProposals;
  final int pendingProposals;
  final int acceptedProposals;

  BuyerDashboard({
    required this.totalBids,
    required this.activeBids,
    required this.acceptedBids,
    required this.totalProposals,
    required this.pendingProposals,
    required this.acceptedProposals,
  });

  factory BuyerDashboard.fromJson(Map<String, dynamic> json) {
    return BuyerDashboard(
      totalBids: json['totalBids'] as int? ?? 0,
      activeBids: json['activeBids'] as int? ?? 0,
      acceptedBids: json['acceptedBids'] as int? ?? 0,
      totalProposals: json['totalProposals'] as int? ?? 0,
      pendingProposals: json['pendingProposals'] as int? ?? 0,
      acceptedProposals: json['acceptedProposals'] as int? ?? 0,
    );
  }
}
