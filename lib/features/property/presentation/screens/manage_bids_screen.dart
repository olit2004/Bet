import 'package:flutter/material.dart';

class ManageBidsScreen extends StatelessWidget {
  final String propertyId;

  const ManageBidsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Manage Bids Screen for property: $propertyId')),
    );
  }
}
