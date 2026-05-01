import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_app_bar.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/favorite_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            _buildTrendingAuctions(),
            _buildVerifiedListingsInfo(),
            _buildExclusiveRentals(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Hero Section
  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 600, // Tall hero section as per image
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.grey[300],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/images/gigapixel-Hero.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[400],
                  child: const Center(
                    child: Icon(Icons.landscape, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
            // Gradient Overlay for contrast
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.0, 0.5, 0.8, 1.0],
                ),
              ),
            ),
            // Bottom Content Overlays
            Positioned(
              left: 24,
              bottom: 40,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Architectural\n',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.8,
                            height: 1.1,
                          ),
                        ),
                        TextSpan(
                          text: 'Curations',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6FFBBE),
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.8,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 200,
                    child: CustomButton(
                      text: 'Get Started',
                      onPressed: () {
                        context.push('/signup');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Trending Auctions Section
  Widget _buildTrendingAuctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 48.0, bottom: 16.0),
          child: Text(
            'Trending Auctions',
            style: GoogleFonts.inter(
              color: AppColors.primaryText,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.8,
              height: 1.11,
            ),
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildAuctionCard(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuctionCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: const EdgeInsets.only(right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Overlays
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/the glass Pavillion.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.home, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: FavoriteButton(
                  onToggle: (val) {
                    // Logic for favoring auction
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6EFEB3), // Light neon green
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF004D2E),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'VERIFIED',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF004D2E),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors
                        .primaryLightBlue, // Use solid blue or gradient
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STARTING BID',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'ETB 44,250,000',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30), // Space for the overlapping bid box
          // Text Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Glass Pavilion',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Bole, Addis Ababa',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primaryText,
                            height: 1.33,
                          ),
                        ),
                        Text(
                          'BEDS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '6',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primaryText,
                            height: 1.33,
                          ),
                        ),
                        Text(
                          'BATHS',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Verified Listings Info Section
  Widget _buildVerifiedListingsInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Verified Listings',
                  style: GoogleFonts.manrope(
                    color: AppColors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Properties backed by Fayda Digital ID receive higher engagement and offer a secure bidding experience.',
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/Interior.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(
                        Icons.chair_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.primaryText.withValues(alpha: 0.6),
                  ),
                ),
                Center(
                  child: Text(
                    '+24 NEW LISTINGS THIS WEEK',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Exclusive Rentals Section
  Widget _buildExclusiveRentals() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exclusive Rentals',
            style: GoogleFonts.inter(
              color: AppColors.primaryText,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.8,
              height: 1.11,
            ),
          ),
          const SizedBox(height: 20),
          _buildRentalCard(
            'Industrial Loft',
            'Mebrat-hayl, Adama',
            '28,200 ETB',
            'assets/images/Industrial loft.png',
          ),
          const SizedBox(height: 20),
          _buildRentalCard(
            'Skyline Retreat',
            'Bole Medanialem',
            '32,500 ETB',
            'assets/images/skyline retreat.png',
          ),
          const SizedBox(height: 20),
          _buildRentalCard(
            'Garden Estate',
            'CMC, Addis Ababa',
            '25,000 ETB',
            'assets/images/garden state.png',
          ),
        ],
      ),
    );
  }

  Widget _buildRentalCard(
    String title,
    String location,
    String price,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.home_work, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FavoriteButton(
                  onToggle: (val) {
                    // Logic for favoring rental
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: GoogleFonts.manrope(
                          color: const Color(
                            0xFF007C54,
                          ), // Green shade for price
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: ' / month',
                        style: GoogleFonts.inter(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
