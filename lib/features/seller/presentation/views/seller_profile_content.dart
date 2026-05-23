import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/seller_button.dart';
import 'package:bet/features/seller/presentation/widgets/performance_card.dart';
import 'package:bet/features/seller/presentation/widgets/profile_stat.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../providers/seller_profile_provider.dart';

class SellerProfileContent extends ConsumerStatefulWidget {
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
  ConsumerState<SellerProfileContent> createState() => _SellerProfileContentState();
}

class _SellerProfileContentState extends ConsumerState<SellerProfileContent> {
  bool _isUploadingImage = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _isUploadingImage = true);
      try {
        await ref.read(authNotifierProvider.notifier).uploadProfileImage(pickedFile);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update image: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isUploadingImage = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final statsAsync = ref.watch(sellerProfileStatsProvider(widget.userId));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) ...[
            _buildHeader(context),
            const SizedBox(height: 28),
          ],

          // ── Profile Avatar ──
          Center(
            child: GestureDetector(
              onTap: _pickAndUploadImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
                        ? NetworkImage('http://localhost:8080${user.avatarUrl}') as ImageProvider
                        : null,
                    child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  if (_isUploadingImage)
                    const CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Name ──
          Center(
            child: Text(
              user?.name ?? 'Seller',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primaryText,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Bio/Email ──
          Center(
            child: Text(
              user?.email ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Dynamic Stats ──
          statsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Failed to load stats: $error',
                style: const TextStyle(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
            data: (stats) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Inline Stats Row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileStat(
                      value: stats.activeProperties.toString(),
                      label: 'LISTINGS',
                      valueColor: AppColors.primaryText,
                    ),
                    const SizedBox(width: 40),
                    ProfileStat(
                      value: stats.totalBids.toString(),
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
                PerformanceCard(
                  label: 'TOTAL VIEWS',
                  value: stats.totalViews.toString(),
                  subtitle: 'Across all properties',
                  icon: Icons.visibility_rounded,
                  valueColor: const Color(0xFF00684A),
                ),
                const SizedBox(height: 16),

                PerformanceCard(
                  label: 'CONVERSION RATE',
                  value: stats.conversionRate,
                  subtitle: 'Bids per view',
                  icon: Icons.trending_up_rounded,
                  valueColor: AppColors.primaryText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Logout Button ──
          SellerButton(
            text: 'LOGOUT',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
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
              onTap: widget.onBack,
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
