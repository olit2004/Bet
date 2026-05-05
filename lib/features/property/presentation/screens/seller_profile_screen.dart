import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/seller_profile_content.dart';

/// Full-screen version of the Seller Profile, used when navigated to
/// via the feature route (/seller-profile/:userId).
/// Wraps [SellerProfileContent] in a Scaffold with the back-arrow header.
class SellerProfileScreen extends StatelessWidget {
  final String userId;

  const SellerProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SellerProfileContent(
          userId: userId,
          showHeader: true,
          onBack: () => context.pop(),
        ),
      ),
    );
  }
}
