import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/features/buyer/buyer_routes.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppLogo(size: 24, showText: false),
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
      body: Column(
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
                _buildStatCard('12', 'ACTIVE BIDS', const Color(0xFF374CE2)),
                _buildStatCard('4', 'PROPOSALS', const Color(0xFF059669)),
                _buildStatCard('\$4.2M', 'ASSET VALUE', const Color(0xFF05345C)),
                _buildStatCard('7', 'HOUSES RENTED', const Color(0xFF9CA3AF)),
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
          Expanded(
            child: _tabController.index == 0 
                ? _buildActiveBidsList() 
                : _buildHistoryList(),
          ),
        ],
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
    final properties = context.watch<PropertyProvider>().properties;
    
    if (properties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final villa = properties.firstWhere((p) => p.id == '1', orElse: () => properties.first);
    final apartments = properties.firstWhere((p) => p.id == '2', orElse: () => properties.first);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildBidCard(
          title: 'Exquisite Villa',
          location: 'Garment • 500 SQM',
          price: '13,100,000 ETB',
          timeLeft: '2d 14h 22m',
          status: 'WINNING BID',
          statusColor: const Color(0xFFD1FAE5),
          statusTextColor: const Color(0xFF059669),
          onTap: () => context.push('${BuyerRoutes.detail}/${villa.id}', extra: villa),
        ),
        _buildBidCard(
          title: 'Elegant Apartments',
          location: 'Tsehay Realstate • 3 Units',
          price: '7,450,000 ETB',
          status: 'OUTBID',
          statusColor: const Color(0xFFFFEDD5),
          statusTextColor: const Color(0xFFEA580C),
          showRaiseButton: true,
          onTap: () => context.push('${BuyerRoutes.detail}/${apartments.id}', extra: apartments),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    final properties = context.watch<PropertyProvider>().properties;
    
    if (properties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final villa = properties.firstWhere((p) => p.id == '1', orElse: () => properties.first);
    final apartments = properties.firstWhere((p) => p.id == '2', orElse: () => properties.first);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildHistoryCard(
          title: 'Elegant Apartments',
          description: 'Look for the best apartments in Addis Ababa. We provide all the things you require including in house equipments.',
          date: 'JULY 12, 2023',
          badgeText: 'RENTED',
          badgeColor: const Color(0xFFE0E7FF),
          badgeTextColor: const Color(0xFF374CE2),
          price: '30,000 ETB',
          icon: Icons.description_outlined,
          iconColor: const Color(0xFF374CE2),
          onTap: () => context.push('${BuyerRoutes.detail}/${apartments.id}', extra: apartments),
        ),
        _buildHistoryCard(
          title: 'Grand Villa',
          description: 'Sky-scraping houses for your needs. We provide the best that exists in the whole country wide.',
          date: 'JUNE 28, 2023',
          badgeText: 'BOUGHT',
          badgeColor: const Color(0xFFD1FAE5),
          badgeTextColor: const Color(0xFF059669),
          price: '10,420,000 ETB',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF059669),
          onTap: () => context.push('${BuyerRoutes.detail}/${villa.id}', extra: villa),
        ),
      ],
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
