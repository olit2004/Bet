import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/property_model.dart';

class PropertySpecsGrid extends StatelessWidget {
  final List<PropertySpec> specs;

  const PropertySpecsGrid({
    super.key,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputFill),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: specs.length,
        itemBuilder: (context, index) {
          final spec = specs[index];
          return _SpecItem(spec: spec);
        },
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final PropertySpec spec;

  const _SpecItem({required this.spec});

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
          child: _getIcon(spec.label, spec.icon),
        ),
        const SizedBox(height: 8),
        Text(
          spec.value,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          spec.label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.secondaryText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getIcon(String label, String? iconName) {
    // If iconName is provided and starts with 'material:', we could try to map it
    // For now, we'll map based on common labels or use the provided iconName as a hint
    
    IconData iconData;
    final lowerLabel = label.toLowerCase();
    
    if (lowerLabel.contains('bed')) {
      iconData = Icons.king_bed_outlined;
    } else if (lowerLabel.contains('bath')) {
      iconData = Icons.bathtub_outlined;
    } else if (lowerLabel.contains('area') || lowerLabel.contains('sqft') || lowerLabel.contains('size')) {
      iconData = Icons.square_foot_outlined;
    } else if (lowerLabel.contains('floor')) {
      iconData = Icons.layers_outlined;
    } else {
      iconData = Icons.info_outline;
    }

    return Icon(
      iconData,
      color: AppColors.primaryBlue,
      size: 24,
    );
  }
}
