import 'package:flutter/material.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '${property.currency} ',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: property.imageUrls.isNotEmpty
                      ? _buildImage(property.imageUrls.first)
                      : Container(
                          height: 320,
                          color: AppColors.inputFill,
                          child: const Icon(Icons.image_outlined, 
                              color: AppColors.secondaryText, size: 48),
                        ),
                ),
                // Verified Badge Overlay
                if (property.isVerified)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, 
                              color: AppColors.verifiedText, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'VERIFIED',
                            style: GoogleFonts.inter(
                              color: AppColors.verifiedText,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Price / Bid Overlay
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildPriceOverlay(currencyFormat),
                ),
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AppColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildCategoryTag(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        property.address,
                        style: GoogleFonts.inter(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.inputFill),
                  const SizedBox(height: 16),
                  // Specs Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: property.specs.take(3).map((spec) {
                      return Row(
                        children: [
                          Icon(
                            _getIconData(spec.icon ?? spec.label),
                            size: 20,
                            color: AppColors.secondaryText.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            spec.value,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceOverlay(NumberFormat format) {
    final isAuction = property.id == '1';
    
    if (isAuction) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bidOrange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CURRENT BID',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryText.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  format.format(property.price),
                  style: GoogleFonts.manrope(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Text(
              '22h Left',
              style: GoogleFonts.inter(
                color: AppColors.primaryText,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PRICE',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            format.format(property.price),
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTag() {
    String label = 'FREEHOLD';
    Color bgColor = AppColors.primaryBlue.withValues(alpha: 0.1);
    Color textColor = AppColors.primaryBlue;

    if (property.category == PropertyCategory.rent) {
      label = 'RENT';
    } else if (property.category == PropertyCategory.commercial) {
      label = 'COMMERCIAL';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        height: 320,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorContainer(),
      );
    }
    return Image.asset(
      url,
      height: 320,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildErrorContainer(),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      height: 320,
      color: AppColors.inputFill,
      child: const Icon(Icons.image_not_supported_outlined, 
          color: AppColors.secondaryText, size: 48),
    );
  }

  IconData _getIconData(String iconName) {
    final lowerName = iconName.toLowerCase();
    if (lowerName.contains('bed') || lowerName.contains('studio')) {
      return Icons.king_bed_outlined;
    } else if (lowerName.contains('bath')) {
      return Icons.bathtub_outlined;
    } else if (lowerName.contains('area') || lowerName.contains('sqm') || lowerName.contains('sqft') || lowerName.contains('size')) {
      return Icons.square_foot_outlined;
    } else if (lowerName.contains('balcony')) {
      return Icons.balcony_outlined;
    }
    return Icons.info_outline;
  }
}
