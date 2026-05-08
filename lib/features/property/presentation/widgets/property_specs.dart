import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../../domain/models/property_model.dart';

class PropertySpecsGrid extends StatelessWidget {
  final List<PropertySpec> specs;
  final bool isRoundedStyle;

  const PropertySpecsGrid({
    super.key,
    required this.specs,
    this.isRoundedStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isRoundedStyle) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: specs.map((spec) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _RoundedSpecItem(spec: spec),
          ),
        )).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputFill),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: specs.map((spec) => _CircularSpecItem(spec: spec)).toList(),
      ),
    );
  }
}

class _RoundedSpecItem extends StatelessWidget {
  final PropertySpec spec;
  const _RoundedSpecItem({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getIcon(spec.label),
          const SizedBox(height: 12),
          Text(
            spec.value,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: AppColors.primaryText,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            spec.label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.secondaryText.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CircularSpecItem extends StatelessWidget {
  final PropertySpec spec;
  const _CircularSpecItem({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.inputFill.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: _getIcon(spec.label),
        ),
        const SizedBox(height: 8),
        Text(
          spec.value,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          spec.label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColors.secondaryText),
        ),
      ],
    );
  }
}

Widget _getIcon(String label) {
  IconData iconData;
  final lowerLabel = label.toLowerCase();
  
  // Design preference for Rent layout: use bed icon for all bedroom/studio types
  if (lowerLabel.contains('bed') || lowerLabel.contains('studio')) {
    iconData = Icons.king_bed_outlined;
  } else if (lowerLabel.contains('bath')) {
    iconData = Icons.bathtub_outlined;
  } else if (lowerLabel.contains('area') || lowerLabel.contains('sqm') || lowerLabel.contains('size')) {
    iconData = Icons.architecture_outlined;
  } else {
    iconData = Icons.info_outline;
  }
  return Icon(iconData, color: AppColors.primaryBlue, size: 28);
}
