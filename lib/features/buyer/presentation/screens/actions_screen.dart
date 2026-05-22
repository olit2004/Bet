import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/buyer/application/buyer_providers.dart';

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

  String _formatCurrency(num amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(amount)} ETB';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(date).toUpperCase();
    } catch (_) {
      return dateStr;
    }
  }

  String _timeLeft(String? endTimeStr) {
    if (endTimeStr == null) return 'No deadline';
    try {
      final endTime = DateTime.parse(endTimeStr);
      final diff = endTime.difference(DateTime.now());
      if (diff.isNegative) return 'Ended';
      return '${diff.inDays}d ${diff.inHours % 24}h ${diff.inMinutes % 60}m';
    } catch (_) {
      return 'N/A';
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Stats Grid — from dashboard provider
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: dashboardAsync.when(
                data: (dashboard) => GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  children: [
                    _buildStatCard('${dashboard.activeBids}', 'ACTIVE BIDS', const Color(0xFF374CE2)),
                    _buildStatCard('${dashboard.totalProposals}', 'PROPOSALS', const Color(0xFF059669)),
                    _buildStatCard('${dashboard.totalBids}', 'TOTAL BIDS', const Color(0xFF05345C)),
                    _buildStatCard('${dashboard.acceptedBids}', 'ACCEPTED BIDS', const Color(0xFF9CA3AF)),
                  ],
                ),
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF374CE2))),
                ),
                error: (e, _) => GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.4,
                  children: [
                    _buildStatCard('0', 'ACTIVE BIDS', const Color(0xFF374CE2)),
                    _buildStatCard('0', 'PROPOSALS', const Color(0xFF059669)),
                    _buildStatCard('0', 'TOTAL BIDS', const Color(0xFF05345C)),
                    _buildStatCard('0', 'ACCEPTED BIDS', const Color(0xFF9CA3AF)),
                  ],
                ),
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
                ? _buildActiveBidsList() 
                : _buildHistoryList(),
            
            const SizedBox(height: 32),
          ],
        ),
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

  Widget _buildActiveBidsList() {
    final bidsAsync = ref.watch(myBidsProvider);
    
    return bidsAsync.when(
      data: (bids) {
        final activeBids = bids.where((b) => b['status'] == 'ACTIVE').toList();
        
        if (activeBids.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.gavel_outlined, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No active bids yet',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Place a bid on a property to see it here',
                    style: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: activeBids.length,
          itemBuilder: (context, index) {
            final bid = activeBids[index];
            final property = bid['property'] as Map<String, dynamic>?;
            final title = property?['title'] ?? 'Unknown Property';
            final location = '${property?['locale'] ?? ''} • ${property?['sqFootage']?.toString() ?? ''} SQM';
            final endTime = property?['endTime'] as String?;

            return _buildBidCard(
              title: title,
              location: location,
              price: _formatCurrency(bid['amount'] as num),
              timeLeft: _timeLeft(endTime),
              status: 'ACTIVE BID',
              statusColor: const Color(0xFFD1FAE5),
              statusTextColor: const Color(0xFF059669),
              onTap: () {
                if (property != null) {
                  context.push('/property/${property['id']}');
                }
              },
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF374CE2))),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.gavel_outlined, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No active bids yet',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Place a bid on a property to see it here',
                style: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final bidsAsync = ref.watch(myBidsProvider);

    return bidsAsync.when(
      data: (bids) {
        // History = non-ACTIVE bids (RETRACTED, ACCEPTED, DECLINED)
        final historyBids = bids.where((b) => b['status'] != 'ACTIVE').toList();

        if (historyBids.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No history yet',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryText,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: historyBids.length,
          itemBuilder: (context, index) {
            final bid = historyBids[index];
            final property = bid['property'] as Map<String, dynamic>?;
            final status = bid['status'] as String? ?? 'UNKNOWN';
            final title = property?['title'] ?? 'Unknown Property';
            final description = property?['description'] ?? '';

            Color badgeColor;
            Color badgeTextColor;
            IconData icon;
            Color iconColor;

            switch (status) {
              case 'ACCEPTED':
                badgeColor = const Color(0xFFD1FAE5);
                badgeTextColor = const Color(0xFF059669);
                icon = Icons.check_circle_outline;
                iconColor = const Color(0xFF059669);
                break;
              case 'DECLINED':
                badgeColor = const Color(0xFFFFEDD5);
                badgeTextColor = const Color(0xFFEA580C);
                icon = Icons.cancel_outlined;
                iconColor = const Color(0xFFEA580C);
                break;
              case 'RETRACTED':
                badgeColor = const Color(0xFFE0E7FF);
                badgeTextColor = const Color(0xFF374CE2);
                icon = Icons.undo;
                iconColor = const Color(0xFF374CE2);
                break;
              default:
                badgeColor = const Color(0xFFE5E7EB);
                badgeTextColor = const Color(0xFF6B7280);
                icon = Icons.info_outline;
                iconColor = const Color(0xFF6B7280);
            }

            return _buildHistoryCard(
              title: title,
              description: description.length > 100 ? '${description.substring(0, 100)}...' : description,
              date: _formatDate(bid['createdAt'] ?? ''),
              badgeText: status,
              badgeColor: badgeColor,
              badgeTextColor: badgeTextColor,
              price: _formatCurrency(bid['amount'] as num),
              icon: icon,
              iconColor: iconColor,
              onTap: () {
                if (property != null) {
                  context.push('/property/${property['id']}');
                }
              },
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF374CE2))),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'No history yet',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
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
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.primaryText,
                  ),
                ),
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
