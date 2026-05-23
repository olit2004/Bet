import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/features/seller/presentation/widgets/seller_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bet/features/seller/presentation/widgets/listing_success_overlay.dart';
import 'package:bet/features/seller/presentation/providers/create_property_provider.dart';
import 'package:bet/features/seller/presentation/providers/seller_properties_provider.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';

class CreatePropertyContent extends ConsumerStatefulWidget {
  const CreatePropertyContent({super.key});

  @override
  ConsumerState<CreatePropertyContent> createState() =>
      _CreatePropertyContentState();
}

class _CreatePropertyContentState extends ConsumerState<CreatePropertyContent> {
  bool _isSubmitting = false;
  final List<XFile> _selectedImages = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  final _sqFootageController = TextEditingController();
  final _priceController = TextEditingController();
  final _endDateController = TextEditingController();

  // 0 = Fixed Price, 1 = Auction
  int _listingType = 0;

  // 0 = Sale, 1 = Rent
  int _listingIntent = 0;

  LatLng _selectedLocation = const LatLng(9.0054, 38.7636);
  String _locationName = 'Bole, Addis Ababa';
  final MapController _mapController = MapController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _sqFootageController.dispose();
    _priceController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createPropertyNotifierProvider);
    final isLoading =
        createState.status == CreatePropertyStatus.loading || _isSubmitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text(
            'Property Details',
            style: GoogleFonts.manrope(
              color: AppColors.primaryText,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 32),

          // ── Image Upload Area ──
          _buildImageUploadArea(context),
          const SizedBox(height: 32),

          // ── Geographic Anchor ──
          _buildGeographicAnchor(context),
          const SizedBox(height: 32),

          // ── Property Title ──
          _buildSectionLabel(context, 'PROPERTY TITLE'),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _titleController,
            hint: 'e.g. Minimalist Concrete Villa',
          ),
          const SizedBox(height: 24),

          // ── Architectural Description ──
          _buildSectionLabel(context, 'ARCHITECTURAL DESCRIPTION'),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _descriptionController,
            hint: 'Describe the soul of this space...',
            maxLines: 4,
          ),
          const SizedBox(height: 24),

          // Value Point & SQ Footage
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(context, 'VALUE POINT'),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _valueController,
                      hint: '€ 0.00',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(context, 'SQ FOOTAGE'),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _sqFootageController,
                      hint: 'm²',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Listing Type Toggle
          _buildSectionLabel(context, 'LISTING TYPE'),
          const SizedBox(height: 12),
          _buildListingTypeToggle(context),
          const SizedBox(height: 24),

          // Fixed Price / Starting Price (Dynamic Fields)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            child: _listingType == 0
                ? Column(
                    key: const ValueKey('fixed_price_fields'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(context, 'FIXED PRICE'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _priceController,
                        hint: 'e.g. 2,000,000 (Birr)',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('auction_fields'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel(context, 'STARTING PRICE'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _priceController,
                        hint: 'e.g. 2,000,000 (Birr)',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      _buildSectionLabel(context, 'ENDING DATE'),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _endDateController,
                        hint: 'Select Date',
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primaryLightBlue,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.primaryText,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            _endDateController.text =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T23:59:59Z";
                          }
                        },
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 28),

          // Listing Intent
          _buildListingIntent(context),
          const SizedBox(height: 32),

          //Create Property Button
          _buildCreateButton(context, isLoading),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Image Upload Area

  Widget _buildImageUploadArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length + 1,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == _selectedImages.length) {
                  return _buildAddMoreImagesButton();
                }
                return _buildImageThumbnail(_selectedImages[index], index);
              },
            ),
          )
        else
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Camera icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primaryBlue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Upload Architectural\nImagery',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: AppColors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap to select high-resolution captures\nof the property.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.secondaryText.withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddMoreImagesButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.2),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              color: AppColors.primaryBlue,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Add More',
              style: GoogleFonts.inter(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(XFile file, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: kIsWeb
              ? Image.network(
                  file.path,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(file.path),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImages.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  // Geographic Anchor (Interactive Map)
  Widget _buildGeographicAnchor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Geographic Anchor',
              style: GoogleFonts.manrope(
                color: AppColors.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Re-center the map on the selected location
                _mapController.move(_selectedLocation, 15.0);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pick Location',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Interactive Map
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLocation,
                initialZoom: 15.0,
                onTap: (tapPosition, latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                    _locationName =
                        'Lat: ${latLng.latitude.toStringAsFixed(4)}, Long: ${latLng.longitude.toStringAsFixed(4)}';
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.bet.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Location label
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_city_rounded,
                color: AppColors.primaryBlue,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _locationName,
                  style: GoogleFonts.inter(
                    color: AppColors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Listing Type Toggle (Fixed Price / Auction)

  Widget _buildListingTypeToggle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildToggleOption(
            label: 'Fixed Price',
            isActive: _listingType == 0,
            onTap: () => setState(() => _listingType = 0),
          ),
          _buildToggleOption(
            label: 'Auction',
            isActive: _listingType == 1,
            onTap: () => setState(() => _listingType = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                color: isActive ? Colors.white : AppColors.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Listing Intent (Sale / Rent)

  Widget _buildListingIntent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Listing Intent',
          style: GoogleFonts.manrope(
            color: const Color(0xFF0C2442),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          height: 38,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF94A3B8).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleItem(
                'Sale',
                _listingIntent == 0,
                () => setState(() => _listingIntent = 0),
              ),
              _buildToggleItem(
                'Rent',
                _listingIntent == 1,
                () => setState(() => _listingIntent = 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2D3EAF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              color: isActive ? Colors.white : const Color(0xFF0C2442),
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Create Property Button

  Widget _buildCreateButton(BuildContext context, bool isLoading) {
    return SellerButton(
      text: isLoading ? 'Creating...' : 'Create property',
      onPressed: isLoading ? () {} : () => _submitProperty(),
      height: 60,
    );
  }

  Future<void> _submitProperty() async {
    // Validation
    if (_titleController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in at least the title and price.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please upload at least one image of the property.',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Build payload from form fields
    final payload = <String, dynamic>{
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'No description provided.',
      'price': _priceController.text.trim().replaceAll(',', ''),
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'location': _locationName,
      'listingType': _listingType == 0 ? 'FIXED' : 'AUCTION',
      'type': _listingIntent == 0 ? 'SALE' : 'RENT',
    };

    // Optional fields
    if (_valueController.text.trim().isNotEmpty) {
      payload['value'] = _valueController.text.trim().replaceAll(',', '');
    }
    if (_sqFootageController.text.trim().isNotEmpty) {
      payload['sqFootage'] = _sqFootageController.text.trim().replaceAll(
        ',',
        '',
      );
    }
    if (_listingType == 1 && _endDateController.text.trim().isNotEmpty) {
      payload['endingAt'] = _endDateController.text.trim();
    }
    if (_selectedImages.isNotEmpty) {
      payload['images'] = _selectedImages;
    }

    final success = await ref
        .read(createPropertyNotifierProvider.notifier)
        .createProperty(payload);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      // Reset provider state for next creation
      ref.read(createPropertyNotifierProvider.notifier).reset();

      // Invalidate the properties list so it fetches the new item
      final userId = ref.read(authNotifierProvider).user?.id;
      if (userId != null) {
        ref.invalidate(sellerPropertiesProvider(userId));
      }

      showListingSuccessOverlay(
        context,
        onReturnToDashboard: () {
          Navigator.of(context).maybePop();
        },
      );
    } else {
      final errorMsg =
          ref.read(createPropertyNotifierProvider).errorMessage ??
          'Failed to create listing.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg, style: GoogleFonts.inter()),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // Shared Helpers

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: AppColors.secondaryText,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6), // subtle inner shadow/gray
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        style: GoogleFonts.inter(color: AppColors.primaryText, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: AppColors.secondaryText.withValues(alpha: 0.5),
            fontSize: 15,
          ),
          fillColor: AppColors.inputFill,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
