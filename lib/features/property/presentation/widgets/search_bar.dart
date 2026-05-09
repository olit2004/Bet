import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/providers/property_provider.dart';
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
            hintText: 'Search modern lofts, penthouses...',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText, size: 20),
            onChanged: (value) {
              context.read<PropertyProvider>().searchProperties(value);
            },
          ),
        ),
        const SizedBox(height: 20),
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
      padding: const EdgeInsets.only(right: 12.0),
      child: GestureDetector(
        onTap: () => onSelected(true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : AppColors.chipBackground,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.secondaryText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
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
