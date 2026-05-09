import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../widgets/active_auction_card.dart';

class ActiveAuctionsContent extends StatelessWidget {
  const ActiveAuctionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Section
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Live Auctions',
                  value: '2',
                  valueColor: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Bids',
                  value: '4',
                  valueColor: const Color(0xFF00684A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Auctions List
          ActiveAuctionCard(
            imageUrl: 'assets/images/properties/apartment.png',
            isVerified: true,
            timeRemaining: '02h 45m remaining',
            title: 'Skyline\nPenthouse',
            location: 'Yeka, Addis Ababa',
            currentBid: '18,450,000 Birr',
            bidsPlaced: 24,
            onManageAuction: () {
              context.push('/manage-bids/skyline-123');
            },
            onTap: () {
              context.push(
                '/property/skyline-123',
                extra: {
                  'imageUrl': 'assets/images/properties/apartment.png',
                  'title': 'Skyline\nPenthouse',
                  'location': 'Yeka, Addis Ababa',
                },
              );
            },
          ),
          const SizedBox(height: 48),

          ActiveAuctionCard(
            imageUrl: 'assets/images/properties/villa.png',
            isVerified: false,
            timeRemaining: '14h 22m remaining',
            title: 'Azure Heights\nVilla',
            location: 'Nifas Silk-Lafto,Addis Ababa',
            currentBid: '25,120,000 Birr',
            bidsPlaced: 38,
            onManageAuction: () {
              context.push('/manage-bids/azure-123');
            },
            onTap: () {
              context.push(
                '/property/azure-123',
                extra: {
                  'imageUrl': 'assets/images/properties/villa.png',
                  'title': 'Azure Heights\nVilla',
                  'location': 'Nifas Silk-Lafto,Addis Ababa',
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppColors.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
