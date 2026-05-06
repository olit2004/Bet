import 'package:flutter/material.dart';
import '../../domain/models/property_model.dart';
import '../../../../core/constants/app_colors.dart';
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
        width: 280, // Fixed width for horizontal scrolling list if needed, or flexible
        margin: const EdgeInsets.only(right: 16, bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: property.imageUrls.isNotEmpty
                      ? Image.asset(
                          property.imageUrls.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: AppColors.inputFill,
                            child: const Icon(Icons.image_not_supported_outlined, 
                                color: AppColors.secondaryText, size: 40),
                          ),
                        )
                      : Container(
                          height: 180,
                          color: AppColors.inputFill,
                          child: const Icon(Icons.image_outlined, 
                              color: AppColors.secondaryText, size: 40),
                        ),
                ),
                // Price Tag Overlay
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currencyFormat.format(property.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // Verified Badge Overlay
                if (property.isVerified)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: AppColors.success, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'VERIFIED',
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.primaryText,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: AppColors.secondaryText),
                      const SizedBox(width: 4),
                      Text(
                        property.address,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Specs Row
                  Row(
                    children: property.specs.take(3).map((spec) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Row(
                          children: [
                            Icon(
                              _getIconData(spec.icon ?? spec.label),
                              size: 18,
                              color: AppColors.secondaryText.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              spec.value,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText.withValues(alpha: 0.8),
                                  ),
                            ),
                          ],
                        ),
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

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'bed':
      case 'bedroom':
      case 'bedrooms':
        return Icons.king_bed_outlined;
      case 'bath':
      case 'bathroom':
      case 'bathrooms':
        return Icons.bathtub_outlined;
      case 'area':
      case 'sqft':
      case 'm2':
        return Icons.square_foot_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
