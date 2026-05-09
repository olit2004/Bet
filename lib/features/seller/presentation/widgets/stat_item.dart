import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';

/// A reusable widget that displays a single statistic with a label and value.
/// Used on the Seller Dashboard, Seller Profile, and Manage Bids screens.
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.primaryText,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.secondaryText,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w800,
                fontSize: 36,
              ),
        ),
        if (showDivider) ...[
          const SizedBox(height: 16),
          Divider(
            color: AppColors.secondaryText.withValues(alpha: 0.15),
            thickness: 1,
          ),
        ],
      ],
    );
  }
}
