import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/property_detail_provider.dart';
import '../views/create_property_content.dart';

class EditPropertyScreen extends ConsumerWidget {
  final String propertyId;

  const EditPropertyScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Listing',
          style: GoogleFonts.manrope(
            color: AppColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: propertyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load property details: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (property) {
          return SafeArea(
            child: CreatePropertyContent(propertyToEdit: property),
          );
        },
      ),
    );
  }
}
