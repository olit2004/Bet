import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/widgets/bid_info_card.dart';
import 'package:bet/core/property/widgets/upload_container.dart';
import 'package:bet/core/property/widgets/legal_notice_card.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/buyer/application/buyer_providers.dart';

class CounterOfferScreen extends ConsumerStatefulWidget {
  final Property property;

  const CounterOfferScreen({
    super.key,
    required this.property,
  });

  @override
  ConsumerState<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends ConsumerState<CounterOfferScreen> {
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  bool _isLoading = false;
  
  // File state
  String? _filePath;
  List<int>? _fileBytes;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _offerController.text = widget.property.price.toStringAsFixed(0);
    _detailsController.text = "I'm offering to rent this property with a 6-month upfront payment.";
  }

  @override
  void dispose() {
    _offerController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          if (kIsWeb) {
            _fileBytes = result.files.single.bytes;
            _filePath = null;
          } else {
            _filePath = result.files.single.path;
            _fileBytes = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _submitProposal() async {
    final amountText = _offerController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);
    
    final details = _detailsController.text.trim();
    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter proposal details')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final proposalDataSource = ref.read(proposalRemoteDataSourceProvider);
      
      await proposalDataSource.createProposal(
        propertyId: widget.property.id,
        amount: amount,
        details: details,
        proposalFilePath: _filePath,
        proposalFileBytes: _fileBytes,
        proposalFileName: _fileName,
      );
      
      // Invalidate the proposals and dashboard providers so they refresh
      ref.invalidate(myProposalsProvider);
      ref.invalidate(buyerDashboardProvider);
      
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit proposal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
        title: const AppLogo(size: 24, showText: true, isClickable: false),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    widget.property.imageUrls.first,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 220,
                      color: AppColors.inputFill,
                      child: const Icon(Icons.home_outlined, size: 64, color: AppColors.secondaryText),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF67E2A9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars, color: Color(0xFF00684A), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'VERIFIED LISTING',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF00684A),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.property.title,
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.secondaryText),
                const SizedBox(width: 4),
                Text(
                  widget.property.address,
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: BidInfoCard(
                    label: 'Asking Price',
                    value: '${widget.property.price.toStringAsFixed(0)} ETB',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BidInfoCard(
                    label: 'Available',
                    value: 'Now',
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Counter Offer Amount',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: 'Enter amount',
              controller: _offerController,
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  'ETB',
                  style: GoogleFonts.manrope(
                    color: AppColors.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Proposal Details',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your terms...',
                filled: true,
                fillColor: AppColors.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '(Optional) Upload Proposal Document',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            UploadContainer(
              title: _fileName ?? 'Select a proposal to upload',
              subtitle: 'PDF/Image formats are allowed',
              onBrowse: _pickFile,
            ),
            const SizedBox(height: 32),
            const LegalNoticeCard(
              text: 'Counter offering commits you to a legal agreement if accepted by the seller.',
            ),
            const SizedBox(height: 32),
            _isLoading 
              ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
              : CustomButton(
                  text: 'Submit Proposal',
                  onPressed: _submitProposal,
                ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_outline, color: Color(0xFF059669), size: 40),
              ),
              const SizedBox(height: 20),
              Text(
                'Success!',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your proposal has been submitted successfully.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.secondaryText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    context.pop(); // Go back to property screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
