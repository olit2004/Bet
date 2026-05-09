import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/core/property/models/property_model.dart';
import 'package:bet/core/property/widgets/bid_info_card.dart';
import 'package:bet/core/property/widgets/upload_container.dart';
import 'package:bet/core/property/widgets/legal_notice_card.dart';

class CounterOfferScreen extends StatefulWidget {
  final Property property;

  const CounterOfferScreen({
    super.key,
    required this.property,
  });

  @override
  State<CounterOfferScreen> createState() => _CounterOfferScreenState();
}

class _CounterOfferScreenState extends State<CounterOfferScreen> {
  final TextEditingController _offerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _offerController.text = '15,000'; // Default from Figma
  }

  @override
  void dispose() {
    _offerController.dispose();
    super.dispose();
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
        title: Image.asset(
          'assets/images/logo.png',
          height: 32,
          errorBuilder: (context, error, stackTrace) => Text(
            'Beth',
            style: GoogleFonts.manrope(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
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
                  child: Image.asset(
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
                const Expanded(
                  child: BidInfoCard(
                    label: 'Monthly Cost',
                    value: '15,000 ETB',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BidInfoCard(
                    label: 'Released At',
                    value: 'January 7, 2026',
                    icon: Icons.timer_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Counter Offer',
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum increment: \$10,000',
                  style: GoogleFonts.inter(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '1 Counter Offer',
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
              'Select a proposal to upload',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            UploadContainer(
              title: 'Select a proposal to upload',
              subtitle: 'Only PDF format is Allowed:\nCBE-Bank_Statement_Form_Validated.pdf',
              onBrowse: () {},
            ),
            const SizedBox(height: 32),
            const LegalNoticeCard(
              text: 'Counter offering commits you to a legal rent agreement.',
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Submit',
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
