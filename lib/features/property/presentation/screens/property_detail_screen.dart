import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../domain/models/property_model.dart';
import '../widgets/image_carousel.dart';
import '../widgets/property_specs.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const AppLogo(size: 24),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Section
                ImageCarousel(
                  imageUrls: property.imageUrls,
                  height: 350,
                  isVerified: property.isVerified,
                  isOverlapStyle: true,
                ),
                
                // 2. Main Info Card (Overlapping)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: GoogleFonts.manrope(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18, color: AppColors.secondaryText),
                            const SizedBox(width: 4),
                            Text(
                              property.address,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.secondaryText.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Price Card Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: (property.id == '1') 
                            ? _buildDualPriceRow()
                            : _buildSinglePriceColumn(
                                property.category == PropertyCategory.rent ? 'AVERAGE PRICE' : 'LISTING PRICE'
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Property Specs Grid
                      PropertySpecsGrid(specs: property.specs, isRoundedStyle: true),
                      
                      const SizedBox(height: 32),
                      
                      // 4. Architectural Philosophy
                      Text(
                        'ARCHITECTURAL PHILOSOPHY',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue.withValues(alpha: 0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        property.description,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.secondaryText,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 5. Seller Card
                      _buildSellerCard(
                        property.category == PropertyCategory.rent ? 'Landlord' : 'Seller',
                        property.id == '1' ? 'Abebe Tola' : 'Mikias Yared',
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 6. The Locale
                      Text(
                        'THE LOCALE',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue.withValues(alpha: 0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLocaleMap(property.id == '1' ? 'Bole Medhanialem' : 'Sarbet'),
                      
                      const SizedBox(height: 120), // Bottom spacing for fixed button
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 7. Fixed Bottom Button
          _buildFixedBottomButton(
            (property.id == '1') ? 'Place Bid' : 'Rent It',
            (property.id == '1') ? Icons.gavel_outlined : Icons.vpn_key_outlined,
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildDualPriceRow() {
    return Row(
      children: [
        Expanded(child: _buildPriceColumn('LISTING PRICE', property.price, AppColors.primaryBlue)),
        Container(width: 1, height: 40, color: AppColors.primaryBlue.withValues(alpha: 0.1)),
        const SizedBox(width: 16),
        Expanded(child: _buildPriceColumn('HIGHEST BID', property.price * 1.05, AppColors.success)),
      ],
    );
  }

  Widget _buildSinglePriceColumn(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryBlue.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${NumberFormat('#,###').format(property.price)} ETB',
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceColumn(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: color.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${NumberFormat('#,###').format(value)} ${property.currency}',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: label.contains('BID') ? color : AppColors.primaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerCard(String role, String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryText),
              ),
              Text(
                role,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.secondaryText.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocaleMap(String locationName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text(
                locationName,
                style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedBottomButton(String label, IconData icon) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withValues(alpha: 0), Colors.white, Colors.white],
            stops: const [0, 0.2, 1],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
