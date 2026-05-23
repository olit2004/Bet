import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';

class VerifyIdScreen extends ConsumerStatefulWidget {
  const VerifyIdScreen({super.key});

  @override
  ConsumerState<VerifyIdScreen> createState() => _VerifyIdScreenState();
}

class _VerifyIdScreenState extends ConsumerState<VerifyIdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fanController = TextEditingController();
  XFile? _idImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _idImage = pickedFile;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_idImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image of your ID')),
        );
        return;
      }

      setState(() => _isSubmitting = true);
      try {
        await ref.read(authNotifierProvider.notifier).submitVerification(
          _fanController.text.trim(),
          _idImage!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification submitted successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    final isVerified = user?.isVerified ?? false;
    final status = user?.faydaStatus;
    
    // Status Resolution:
    // 1. Verified: if user is verified
    // 2. Pending: if status is PENDING and not verified
    // 3. Unverified: if no submission or rejected
    final hasSubmitted = user?.faydaId != null && user!.faydaId!.isNotEmpty;
    final isPending = !isVerified && status == 'PENDING' && hasSubmitted;
    final isRejected = !isVerified && status == 'REJECTED';
    
    String statusText = 'Unverified';
    Color statusColor = Colors.grey.shade700;
    Color statusBg = Colors.grey.shade100;
    IconData statusIcon = Icons.info_outline;

    if (isVerified) {
      statusText = 'Verified';
      statusColor = const Color(0xFF059669);
      statusBg = const Color(0xFFD1FAE5);
      statusIcon = Icons.verified_user_rounded;
    } else if (isPending) {
      statusText = 'Pending verification';
      statusColor = const Color(0xFFD97706);
      statusBg = const Color(0xFFFEF3C7);
      statusIcon = Icons.hourglass_empty_rounded;
    } else if (isRejected) {
      statusText = 'Unverified (Rejected by Admin)';
      statusColor = const Color(0xFFDC2626);
      statusBg = const Color(0xFFFEE2E2);
      statusIcon = Icons.cancel_outlined;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF374CE2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Verify Your ID',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: GoogleFonts.inter(
                            color: statusColor.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusText,
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (!isVerified && !isPending) ...[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'FAN Number',
                      hintText: 'Enter your Fayda Access Number',
                      controller: _fanController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'FAN Number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'ID Card Image',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _idImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                              child: kIsWeb
                                  ? Image.network(
                                      _idImage!.path,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_idImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.upload_file_rounded, color: AppColors.primaryBlue, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload ID photo',
                                    style: GoogleFonts.inter(
                                      color: AppColors.secondaryText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _isSubmitting
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
                        : SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: 'Submit Verification',
                              onPressed: _submit,
                            ),
                          ),
                  ],
                ),
              ),
            ] else if (isPending) ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.hourglass_bottom_rounded, size: 64, color: AppColors.primaryBlue),
                    const SizedBox(height: 16),
                    Text(
                      'Your verification request is currently under review by our admin team.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 64, color: Color(0xFF059669)),
                    const SizedBox(height: 16),
                    Text(
                      'Congratulations! Your identity has been verified.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
