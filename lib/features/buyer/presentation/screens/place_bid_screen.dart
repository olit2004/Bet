import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/features/auction/application/providers/bid_provider.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/widgets/bid_info_card.dart';
import 'package:bet/core/property/widgets/upload_container.dart';
import 'package:bet/core/property/widgets/legal_notice_card.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class PlaceBidScreen extends ConsumerStatefulWidget {
  final Property property;

  const PlaceBidScreen({
    super.key,
    required this.property,
  });

  @override
  ConsumerState<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends ConsumerState<PlaceBidScreen> {
  final TextEditingController _bidController = TextEditingController();
  PlatformFile? _bankStatementFile;
  bool _isSubmitting = false;

  Future<void> _pickBankStatement() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null) {
      setState(() {
        _bankStatementFile = result.files.single;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _bidController.text = ''; 
    Future.microtask(() {
      ref.read(bidNotifierProvider.notifier).fetchPropertyBids(widget.property.id);
    });
  }

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  double _getHighestBidAmount(BidStateData bidState) {
    if (bidState.bids.isEmpty) {
      return widget.property.price;
    }
    return bidState.bids.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
  }

  String _getHighestBidText(BidStateData bidState) {
    final formatCurrency = NumberFormat.currency(symbol: '', decimalDigits: 0);
    return formatCurrency.format(_getHighestBidAmount(bidState)).trim() + ' ETB';
  }

  String _getEndsInText() {
    if (widget.property.endTime == null) return 'N/A';
    final diff = widget.property.endTime!.difference(DateTime.now());
    if (diff.isNegative) {
      return widget.property.status == 'ACTIVE' ? 'Awaiting Acceptance' : 'Ended';
    }
    
    if (diff.inDays > 0) {
      return '${diff.inDays}d ${diff.inHours % 24}h';
    }
    final hours = diff.inHours;
    final mins = diff.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}h ${mins.toString().padLeft(2, '0')}m';
  }

  Future<void> _submitBid() async {
    final amount = double.tryParse(_bidController.text.replaceAll(',', '')) ?? 0.0;
    final highestBid = _getHighestBidAmount(ref.read(bidNotifierProvider));
    
    if (amount <= highestBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your bid must be greater than the current highest bid!')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(bidNotifierProvider.notifier).placeBid(
        widget.property.id,
        amount,
        bankStatementBytes: _bankStatementFile?.bytes,
        bankStatementFileName: _bankStatementFile?.name,
        bankStatementFilePath: _bankStatementFile?.path,
      );

      if (mounted) {
        final state = ref.read(bidNotifierProvider);
        if (state.status == BidStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error submitting bid')),
          );
        } else if (state.status == BidStatus.success) {
          _showSuccessDialog();
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bidState = ref.watch(bidNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
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
                  child: widget.property.imageUrls.isNotEmpty && (widget.property.imageUrls.first.startsWith('http') || widget.property.imageUrls.first.startsWith('/'))
                      ? Image.network(
                          widget.property.imageUrls.first.startsWith('/') ? 'http://localhost:8080${widget.property.imageUrls.first}' : widget.property.imageUrls.first,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 220,
                            color: AppColors.inputFill,
                            child: const Icon(Icons.home_outlined, size: 64, color: AppColors.secondaryText),
                          ),
                        )
                      : Image.asset(
                          widget.property.imageUrls.isNotEmpty ? widget.property.imageUrls.first : 'assets/images/placeholder.png',
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
                    label: 'Highest Bid',
                    value: _getHighestBidText(bidState),
                    isDark: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BidInfoCard(
                    label: 'Ends In',
                    value: _getEndsInText(),
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Your Strategic Bid',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: 'Enter amount',
              controller: _bidController,
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum increment: 10,000 ETB',
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${bidState.bids.length} active bidders',
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Please Upload Latest Bank Statement',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            UploadContainer(
              title: 'Bank Statement (Optional)',
              subtitle: 'Only PDF format is allowed',
              fileName: _bankStatementFile?.name,
              buttonText: _bankStatementFile != null ? 'Change File' : 'Browse',
              onBrowse: _pickBankStatement,
            ),
            const SizedBox(height: 32),
            const LegalNoticeCard(
              text: 'Bidding commits you to a legal purchase agreement. Funds must be verified within 24 hours of winning.',
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: _isSubmitting ? 'Submitting...' : 'Submit',
              onPressed: _isSubmitting ? () {} : _submitBid,
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
                'Your bid has been placed successfully.',
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
                    context.pop(); // Go back to previous screen
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
