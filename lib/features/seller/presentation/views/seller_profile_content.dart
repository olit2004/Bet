import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/seller_button.dart';
import 'package:bet/features/seller/presentation/widgets/performance_card.dart';
import 'package:bet/features/seller/presentation/widgets/profile_stat.dart';

class SellerProfileContent extends StatelessWidget {
  final String userId;

  final bool showHeader;

  final VoidCallback? onBack;

  const SellerProfileContent({
    super.key,
    required this.userId,
    this.showHeader = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            _buildHeader(context),
            const SizedBox(height: 28),
          ],

          // ── Profile Avatar ──
          Center(
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/seller_profile.png'),
            ),
          ),
          const SizedBox(height: 24),

          // ── Name ──
          Center(
            child: Text(
              'Fayera Gadisa',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primaryText,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Bio ──
          Center(
            child: Text(
              'Architect & Principal Curator focusing on modernist residential heritage and sustainable luxury estates.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Inline Stats Row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileStat(
                value: '8',
                label: 'LISTINGS',
                valueColor: AppColors.primaryText,
              ),
              SizedBox(width: 40),
              ProfileStat(
                value: '42',
                label: 'TOTAL BIDS',
                valueColor: AppColors.primaryText,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // ── Divider ──
          Divider(
            color: AppColors.secondaryText.withValues(alpha: 0.15),
            thickness: 1,
          ),
          const SizedBox(height: 24),

          // ── Section Title ──
          Text(
            'SELLER PERFORMANCE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.secondaryText,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // ── Performance Cards ──
          const PerformanceCard(
            label: 'AVG. BID INCREASE',
            value: '+12.4%',
            subtitle: 'Above initial listing price',
            icon: Icons.trending_up_rounded,
            valueColor: Color(0xFF00684A),
          ),
          const SizedBox(height: 16),

          const PerformanceCard(
            label: 'TIME TO SALE',
            value: '18 Days',
            subtitle: '40% faster than market avg',
            icon: Icons.access_time_rounded,
            valueColor: AppColors.primaryText,
          ),
          const SizedBox(height: 24),

          // ── Logout Button ──
          SellerButton(
            text: 'LOGOUT',
            onPressed: () => context.go('/login'),
            icon: Icons.logout_rounded,
            color: Colors.white,
            textColor: Colors.redAccent,
            border: Border.all(color: Colors.redAccent, width: 1.5),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBack,
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.primaryText,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Profile',
              style: GoogleFonts.manrope(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            context.push('/settings');
          },
          child: Icon(
            Icons.settings_outlined,
            color: AppColors.primaryBlue,
            size: 24,
          ),
        ),
      ],
    );
  }
}
