import 'package:flutter/material.dart';

class ReviewBidScreen extends StatelessWidget {
  final String bidId;

  const ReviewBidScreen({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Review Bid Screen for bid: $bidId')),
    );
  }
}
