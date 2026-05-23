import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/buyer/buyer_routes.dart';
import 'package:bet/features/buyer/application/providers/buyer_provider.dart';
import 'package:bet/features/buyer/domain/entities/buyer_dashboard.dart';

class ActionsScreen extends ConsumerStatefulWidget {
  const ActionsScreen({super.key});

  @override
  ConsumerState<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends ConsumerState<ActionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(buyerDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppLogo(size: 24, showText: false, isClickable: false),
        ),
        leadingWidth: 100,
        title: Text(
          'Actions',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF05345C),
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF374CE2)),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load dashboard: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(buyerDashboardProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // 1. Stats Grid
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.4,
                      children: [
                        _buildStatCard('${dashboard.statistics.activeBids}', 'ACTIVE BIDS', const Color(0xFF374CE2)),
                        _buildStatCard('${dashboard.statistics.totalProposals}', 'PROPOSALS', const Color(0xFF059669)),
                        _buildStatCard('${dashboard.statistics.acceptedBids + dashboard.statistics.acceptedProposals}', 'ACCEPTED OFFERS', const Color(0xFF05345C)),
                        _buildStatCard('${dashboard.statistics.totalBids}', 'TOTAL BIDS', const Color(0xFF9CA3AF)),
                      ],
                    ),
                  ),
                  
                  // 2. Tab Bar (Pill Toggle)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        _buildPillTab('Active Bids', _tabController.index == 0, () {
                          setState(() => _tabController.index = 0);
                        }),
                        const Spacer(),
                        _buildPillTab('History', _tabController.index == 1, () {
                          setState(() => _tabController.index = 1);
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),
                  
                  // 3. Activity List
                  _tabController.index == 0 
                      ? _buildActiveBidsList([
                          ...dashboard.recentBids.where((b) => b.status == 'ACTIVE'),
                          ...dashboard.recentProposals.where((p) => p.status == 'PENDING'),
                        ]..sort((a, b) => b.createdAt.compareTo(a.createdAt))) 
                      : _buildHistoryList(dashboard),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPillTab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF374CE2) : const Color(0xFFE5E7EB).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : const Color(0xFF3D618C),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBidsList(List<DashboardActionItem> activeBids) {
    if (activeBids.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'You do not have any active bids or proposals right now.',
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: activeBids.map((bid) {
        String timeLeft = 'Ended';
        if (bid.property.status == 'ACTIVE') {
          timeLeft = 'Awaiting Acceptance';
        }
        if (bid.property.endTime != null) {
          final diff = bid.property.endTime!.difference(DateTime.now());
          if (!diff.isNegative) {
            final days = diff.inDays;
            final hours = diff.inHours % 24;
            final minutes = diff.inMinutes % 60;
            if (days > 0) {
              timeLeft = '${days}d ${hours}h ${minutes}m';
            } else {
              timeLeft = '${hours}h ${minutes}m';
            }
          }
        }
        
        final isBid = bid.isBid;
        
        return _buildBidCard(
          title: bid.property.title,
          location: bid.property.location,
          price: '${bid.amount.toStringAsFixed(0)} ETB',
          timeLeft: isBid ? timeLeft : null,
          status: bid.status == 'ACTIVE' ? 'PENDING' : bid.status,
          statusColor: (isBid && bid.status != 'ACTIVE') ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
          statusTextColor: (isBid && bid.status != 'ACTIVE') ? const Color(0xFF059669) : const Color(0xFFD97706),
          onTap: () {
            // Push to detail screen, but wait, actions API doesn't return full property
            // We pass propertyId and it will fetch it in PropertyDetailScreen
            context.push('${BuyerRoutes.detail}/${bid.property.id}');
          },
        );
      }).toList(),
    );
  }

  Widget _buildHistoryList(BuyerDashboard dashboard) {
    // Combine all proposals and non-active bids to create the history list
    // Exclude pending proposals (which are shown in the active list)
    final List<DashboardActionItem> historyItems = [
      ...dashboard.recentBids.where((b) => b.status != 'ACTIVE'),
      ...dashboard.recentProposals.where((p) => p.status != 'PENDING')
    ];

    // Sort by createdAt descending
    historyItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (historyItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Your history is empty.',
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: historyItems.map((item) {
        final isAccepted = item.status == 'ACCEPTED';
        final isRejected = item.status == 'REJECTED';
        
        Color badgeColor = const Color(0xFFE0E7FF);
        Color badgeTextColor = const Color(0xFF374CE2);
        IconData icon = item.isBid ? Icons.gavel : Icons.description_outlined;
        Color iconColor = const Color(0xFF374CE2);

        if (isAccepted) {
          badgeColor = const Color(0xFFD1FAE5);
          badgeTextColor = const Color(0xFF059669);
          icon = Icons.check_circle_outline;
          iconColor = const Color(0xFF059669);
        } else if (isRejected) {
          badgeColor = const Color(0xFFFFEDD5);
          badgeTextColor = const Color(0xFFEA580C);
          icon = Icons.cancel_outlined;
          iconColor = const Color(0xFFEA580C);
        }

        return _buildHistoryCard(
          title: item.property.title,
          description: item.property.description.isNotEmpty ? item.property.description : item.property.location,
          date: DateFormat('MMMM d, yyyy').format(item.createdAt).toUpperCase(),
          badgeText: item.status,
          badgeColor: badgeColor,
          badgeTextColor: badgeTextColor,
          price: '${item.amount.toStringAsFixed(0)} ETB',
          icon: icon,
          iconColor: iconColor,
          onTap: () {
            context.push('${BuyerRoutes.detail}/${item.property.id}');
          },
        );
      }).toList(),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String description,
    required String date,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String price,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Text(
                date,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9CA3AF),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: const Color(0xFF05345C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF3D618C),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: badgeTextColor,
                  ),
                ),
              ),
              Text(
                price,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: const Color(0xFF05345C),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildBidCard({
    required String title,
    required String location,
    required String price,
    String? timeLeft,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    bool showRaiseButton = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      color: statusTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT BID',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText.withValues(alpha: 0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: const Color(0xFF00695C),
                      ),
                    ),
                  ],
                ),
                if (timeLeft != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'CLOSES IN',
                        style: GoogleFonts.inter(
                          color: AppColors.secondaryText.withValues(alpha: 0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        timeLeft,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                if (showRaiseButton)
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Raise Bid',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
