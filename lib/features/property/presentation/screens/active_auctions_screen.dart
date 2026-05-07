import 'package:flutter/material.dart';
import '../views/active_auctions_content.dart';

/// Standalone screen for viewing the seller's active auctions (bids).
/// Wraps [ActiveAuctionsContent] inside a Scaffold so it can be
/// used both as a pushed route and as the body of a dashboard tab.
class ActiveAuctionsScreen extends StatelessWidget {
  const ActiveAuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ActiveAuctionsContent(),
      ),
    );
  }
}
