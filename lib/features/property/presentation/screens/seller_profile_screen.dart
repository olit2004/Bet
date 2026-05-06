import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/seller_profile_content.dart';

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
