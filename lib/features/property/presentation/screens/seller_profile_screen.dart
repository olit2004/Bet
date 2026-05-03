import 'package:flutter/material.dart';

class SellerProfileScreen extends StatelessWidget {
  final String userId;

  const SellerProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Seller Profile Screen for user: $userId')),
    );
  }
}
