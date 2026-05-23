import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/core/widgets/custom_text_field.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _bioFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController(
    text: 'Curating architectural masterpieces in the Pacific Northwest. Focused on brutalist and mid-century modern restorations.',
  );

  final _faydaFormKey = GlobalKey<FormState>();
  final _faydaIdController = TextEditingController();
  XFile? _faydaImage;
  bool _isSubmittingVerification = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    _faydaIdController.dispose();
    super.dispose();
  }

  Future<void> _pickFaydaImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _faydaImage = pickedFile;
      });
    }
  }

  Future<void> _submitVerification() async {
    if (_faydaFormKey.currentState!.validate() && _faydaImage != null) {
      setState(() => _isSubmittingVerification = true);
      try {
        await ref.read(authNotifierProvider.notifier).submitVerification(
          _faydaIdController.text,
          _faydaImage!,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification submitted successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmittingVerification = false);
        }
      }
    } else if (_faydaImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image of your Fayda ID')),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

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
          'Settings',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Verification Section ---
            Text(
              'Identity Verification',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            _buildVerificationStatus(user?.isVerified, user?.faydaStatus),
            const SizedBox(height: 16),
            if (user?.faydaStatus == null || user?.faydaStatus == 'REJECTED') ...[
              Form(
                key: _faydaFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Fayda ID Number',
                      hintText: 'Enter your 12-digit Fayda ID',
                      controller: _faydaIdController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Fayda ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fayda ID Image',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickFaydaImage,
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _faydaImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _faydaImage!.path,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.upload_file, color: AppColors.primaryBlue, size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload ID image',
                                    style: GoogleFonts.inter(
                                      color: AppColors.secondaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isSubmittingVerification
                        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
                        : CustomButton(
                            text: 'Submit Verification',
                            onPressed: _submitVerification,
                          ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            
            Text(
              'Update Profile',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _bioFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Bio',
                    hintText: 'Tell us about yourself',
                    controller: _bioController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bio cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Update Bio',
                    onPressed: () {
                      if (_bioFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bio updated successfully')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 32),
            Text(
              'Change Password',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Old Password',
                    hintText: 'Enter old password',
                    controller: _oldPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'New Password',
                    hintText: 'Enter new password',
                    controller: _newPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter new password',
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Update Password',
                    onPressed: () {
                      if (_passwordFormKey.currentState!.validate()) {
                        _showSuccessDialog();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 32),
            Text(
              'Danger Zone',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showDeleteDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D4F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
                'Password updated successfully.',
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

  Widget _buildVerificationStatus(bool? isVerified, String? status) {
    Color bgColor;
    Color textColor;
    String text;

    if (isVerified == true) {
      bgColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF059669);
      text = 'Verified Account';
    } else if (status == 'PENDING') {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      text = 'Verification Pending';
    } else if (status == 'REJECTED') {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFDC2626);
      text = 'Verification Rejected. Please try again.';
    } else {
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade700;
      text = 'Unverified Account';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified == true ? Icons.verified : Icons.info_outline,
            color: textColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete Account?',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.secondaryText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: AppColors.secondaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic to delete account
                      Navigator.pop(context);
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
