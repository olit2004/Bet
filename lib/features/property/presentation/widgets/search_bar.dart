import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/property_model.dart';
import '../providers/property_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class PropertySearchBar extends StatefulWidget {
  const PropertySearchBar({super.key});

  @override
  State<PropertySearchBar> createState() => _PropertySearchBarState();
}

class _PropertySearchBarState extends State<PropertySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Search TextField
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomTextField(
            hintText: 'I am looking for property for rent or buy',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
            onChanged: (value) {
              context.read<PropertyProvider>().searchProperties(value);
            },
            suffixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.tune, color: AppColors.primaryBlue, size: 20),
                onPressed: () {
                  // Future: Open advanced filters
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal Scrollable Category Chips
        Consumer<PropertyProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildCategoryChip(
                    label: 'All',
                    isSelected: provider.selectedCategory == null,
                    onSelected: (selected) {
                      if (selected) {
                        provider.filterByCategory(null);
                        _searchController.clear();
                      }
                    },
                  ),
                  ...PropertyCategory.values.map((category) {
                    return _buildCategoryChip(
                      label: category.name.capitalize(),
                      isSelected: provider.selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          provider.filterByCategory(category);
                        } else {
                          provider.filterByCategory(null);
                        }
                        _searchController.clear();
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.secondaryText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primaryBlue : AppColors.inputFill,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
