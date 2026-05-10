import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/core/property/models/property_model.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;
  final String imageUrl;
  final String title;
  final String location;
  final Property? property;

  const PropertyDetailsScreen({
    super.key,
    required this.propertyId,
    required this.imageUrl,
    required this.title,
    required this.location,
    this.property,
  });

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF8FAFC);
    const darkBlue = Color(0xFF05345C);

    const greenColor = Color(0xFF008955);
    const grayText = Color(0xFF64748B);

    final formatCurrency = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 0);
    final String listingPrice = property != null ? formatCurrency.format(property!.price).replaceAll('ETB ', '') + ' ETB' : '12,450,000 ETB';
    // Mock highest bid (e.g., 5% higher)
    final String highestBid = property != null ? formatCurrency.format(property!.price * 1.05).replaceAll('ETB ', '') + ' ETB' : '13,100,000 ETB';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () => context.pop(),
        ),
        title: const AppLogo(size: 24, showText: true, isClickable: false),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Section
            Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: imageUrl.startsWith('assets/')
                      ? Image.asset(imageUrl, fit: BoxFit.cover)
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.inputFill,
                            child: const Icon(Icons.image_outlined, size: 48, color: grayText),
                          ),
                        ),
                ),
                // Photos Pill
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '1 / 8 PHOTOS',
                      style: GoogleFonts.inter(
                        color: darkBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section overlapping the image
            Transform.translate(
              offset: const Offset(0, -40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Floating Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.manrope(
                              color: darkBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: grayText, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: GoogleFonts.inter(
                                  color: grayText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          (property?.category == PropertyCategory.buy || property == null)
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F5FF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'LISTING PRICE',
                                              style: GoogleFonts.inter(
                                                color: grayText,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              listingPrice,
                                              style: GoogleFonts.manrope(
                                                color: darkBlue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 30,
                                        color: Colors.black.withValues(alpha: 0.05),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'HIGHEST BID',
                                              style: GoogleFonts.inter(
                                                color: greenColor,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              highestBid,
                                              style: GoogleFonts.manrope(
                                                color: greenColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F5FF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'AVERAGE PRICE',
                                              style: GoogleFonts.inter(
                                                color: grayText,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              listingPrice,
                                              style: GoogleFonts.manrope(
                                                color: darkBlue,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Specs Row
                    _buildDynamicSpecs(),

                    const SizedBox(height: 32),

                    // Architectural Philosophy
                    Text(
                      'ARCHITECTURAL PHILOSOPHY',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3D618C),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      property?.description ??
                          'Designed by renowned architect Marcus Thorne, this residence serves as a masterful dialogue between organic textures and stark industrial lines. Featuring floor-to-ceiling glass that dissolves the boundary between the interior gallery and the surrounding eucalyptus groves.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF475569),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Seller Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              const CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage('assets/images/avater.png'),
                                backgroundColor: Color(0xFFE2E8F0),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: greenColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property?.sellerName ?? 'Abebe Tola',
                                style: GoogleFonts.manrope(
                                  color: darkBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                (property?.category == PropertyCategory.rent || property?.category == PropertyCategory.commercial) ? 'Landlord' : 'Seller',
                                style: GoogleFonts.inter(
                                  color: grayText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // The Locale Map
                    Text(
                      'THE LOCALE',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF3D618C),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9), // Lighter gray
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                            ),
                            child: Image.asset(
                              'assets/images/properties/map.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Fake Map Pin
                          const Positioned(
                            top: 80,
                            left: 0,
                            right: 0,
                            child: Icon(Icons.location_on, color: Colors.red, size: 32),
                          ),
                          // Location Pill
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                property?.locale ?? 'Bole Medhanialem',
                                style: GoogleFonts.inter(
                                  color: darkBlue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40), // Padding to account for the -40 offset
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              if (property != null) {
                if (property!.category == PropertyCategory.rent || property!.category == PropertyCategory.commercial) {
                  context.pushNamed('counter-offer', pathParameters: {'id': propertyId}, extra: property);
                } else {
                  context.pushNamed('place-bid', pathParameters: {'id': propertyId}, extra: property);
                }
              }
            },
            icon: Icon(
              (property?.category == PropertyCategory.rent || property?.category == PropertyCategory.commercial) ? Icons.vpn_key_outlined : Icons.gavel_rounded,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              (property?.category == PropertyCategory.rent || property?.category == PropertyCategory.commercial) ? 'Rent It' : 'Place Bid',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A60FF),
              elevation: 4,
              shadowColor: const Color(0xFF4A60FF).withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF4A60FF), size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.manrope(
                color: const Color(0xFF05345C),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSpecs() {
    if (property == null || property!.specs.isEmpty) {
      return Row(
        children: [
          _buildSpecCard(Icons.king_bed_outlined, '5', 'BEDS'),
          const SizedBox(width: 12),
          _buildSpecCard(Icons.bathtub_outlined, '4', 'BATHS'),
          const SizedBox(width: 12),
          _buildSpecCard(Icons.square_foot_outlined, '500', 'SQM'),
        ],
      );
    }

    final specs = property!.specs.take(3).toList();
    return Row(
      children: specs.asMap().entries.map((entry) {
        final index = entry.key;
        final spec = entry.value;
        final isLast = index == specs.length - 1;
        
        return Expanded(
          child: Row(
            children: [
              _buildSpecCard(
                _getIconForString(spec.icon ?? spec.label),
                spec.value,
                spec.label.toUpperCase(),
              ),
              if (!isLast) const SizedBox(width: 12),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'bed':
      case 'beds':
      case 'bedroom':
      case 'bedrooms':
        return Icons.king_bed_outlined;
      case 'bath':
      case 'baths':
      case 'bathtub':
        return Icons.bathtub_outlined;
      case 'square_foot':
      case 'sqm':
      case 'space':
        return Icons.square_foot_outlined;
      case 'local_parking':
      case 'parking':
        return Icons.local_parking_outlined;
      default:
        return Icons.king_bed_outlined; // Default fallback icon
    }
  }

}
