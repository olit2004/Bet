import 'package:flutter/material.dart';
import '../views/active_auctions_content.dart';

class ActiveAuctionsScreen extends StatelessWidget {
  const ActiveAuctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: ActiveAuctionsContent()));
  }
}
