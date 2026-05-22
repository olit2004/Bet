import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bet/core/constants/app_colors.dart';
import '../../application/buyer_providers.dart';

class FaydaUploadPage extends ConsumerStatefulWidget {
  const FaydaUploadPage({super.key});

  @override
  ConsumerState<FaydaUploadPage> createState() => _FaydaUploadPageState();
}

class _FaydaUploadPageState extends ConsumerState<FaydaUploadPage> {
  final _faydaIdController = TextEditingController();
  String? _pickedFilePath;
  Uint8List? _pickedFileBytes;
  String? _pickedFileName;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedFilePath = file.path;
        _pickedFileBytes = file.bytes;
        _pickedFileName = file.name;
      });
    }
  }

  Future<void> _submit() async {
    if (_faydaIdController.text.trim().isEmpty) {
      _showSnack('Please enter your Fayda ID number.', isError: true);
      return;
    }
    if (_pickedFilePath == null && _pickedFileBytes == null) {
      _showSnack('Please select an image of your Fayda ID card.', isError: true);
      return;
    }

    setState(() => _isUploading = true);
    try {
      final repo = ref.read(buyerRepositoryProvider);
      await repo.verifyFayda(
        faydaId: _faydaIdController.text.trim(),
        imagePath: _pickedFilePath,
        imageBytes: _pickedFileBytes,
        fileName: _pickedFileName ?? 'fayda_image',
      );
      ref.invalidate(buyerProfileProvider);
      if (mounted) {
        _showSnack('Fayda ID submitted! Awaiting admin verification.', isError: false);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnack(e.toString().replaceAll('Exception: ', ''), isError: true);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: GoogleFonts.inter(color: Colors.white))),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildStatusBadge(String? faydaStatus) {
    if (faydaStatus == null) return const SizedBox.shrink();

    final configs = <String, Map<String, dynamic>>{
      'VERIFIED': {
        'icon': Icons.verified_rounded,
        'label': 'Verified by Admin',
        'bg': const Color(0xFFD1FAE5),
        'fg': const Color(0xFF059669),
      },
      'PENDING': {
        'icon': Icons.hourglass_empty_rounded,
        'label': 'Pending Admin Review',
        'bg': const Color(0xFFFEF3C7),
        'fg': const Color(0xFFD97706),
      },
      'REJECTED': {
        'icon': Icons.cancel_outlined,
        'label': 'Rejected — Please Resubmit',
        'bg': const Color(0xFFFFE4E6),
        'fg': const Color(0xFFDC2626),
      },
    };

    final c = configs[faydaStatus] ?? configs['PENDING']!;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c['bg'] as Color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(c['icon'] as IconData, color: c['fg'] as Color, size: 20),
          const SizedBox(width: 10),
          Text(
            c['label'] as String,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: c['fg'] as Color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _faydaIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(buyerProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Fayda ID Verification',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          final alreadyVerified = profile.faydaStatus == 'VERIFIED';

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF374CE2), Color(0xFF5C6EF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.fingerprint, color: Colors.white, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Fayda Digital ID',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Upload your Fayda ID card to get verified. An admin will review your document.',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status badge
                if (profile.faydaStatus != null) ...[
                  _buildStatusBadge(profile.faydaStatus),
                  const SizedBox(height: 24),
                ],

                // Show existing image if uploaded
                if (profile.faydaImageUrl != null) ...[
                  Text(
                    'Submitted ID Card',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'http://localhost:8080${profile.faydaImageUrl}',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image_not_supported_outlined,
                                color: AppColors.secondaryText, size: 40),
                            const SizedBox(height: 8),
                            Text('Image unavailable',
                                style: GoogleFonts.inter(color: AppColors.secondaryText)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Divider(),
                  const SizedBox(height: 20),
                ],

                // Upload form (hidden if already VERIFIED)
                if (!alreadyVerified) ...[
                  Text(
                    profile.faydaStatus == 'PENDING' ? 'Resubmit (Optional)' : 'Submit Your Fayda ID',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter your Fayda ID number and upload a clear photo of your ID card.',
                    style: GoogleFonts.inter(
                        color: AppColors.secondaryText, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Fayda ID TextField
                  TextField(
                    controller: _faydaIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Fayda ID Number',
                      hintText: 'Enter your 10-12 digit Fayda ID',
                      prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primaryBlue),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // File picker area
                  GestureDetector(
                    onTap: _pickImage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: (_pickedFileBytes != null) ? 200 : 150,
                      decoration: BoxDecoration(
                        color: (_pickedFileBytes != null) ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (_pickedFileBytes != null)
                              ? Colors.transparent
                              : AppColors.primaryBlue.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (_pickedFileBytes != null)
                          ? Stack(
                              children: [
                                Image.memory(
                                  _pickedFileBytes!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.refresh_rounded,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 6),
                                          Text('Change',
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.upload_file_outlined,
                                      color: AppColors.primaryBlue, size: 28),
                                ),
                                const SizedBox(height: 12),
                                Text('Tap to upload ID card photo',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                        fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('JPG, PNG or WebP  •  Max 5MB',
                                    style: GoogleFonts.inter(
                                        color: AppColors.secondaryText, fontSize: 12)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isUploading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.primaryBlue.withValues(alpha: 0.5),
                      ),
                      child: _isUploading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text('Submit for Verification',
                              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ] else ...[
                  // Already VERIFIED
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            color: Color(0xFF059669), size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Account Verified!',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF059669),
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text('Your Fayda ID has been approved by an admin.',
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF059669), fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
