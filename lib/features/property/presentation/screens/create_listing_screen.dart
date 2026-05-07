import 'package:flutter/material.dart';
import '../views/create_property_content.dart';

/// Standalone screen for creating a new property listing.
/// Wraps [CreatePropertyContent] inside a Scaffold so it can be
/// used both as a pushed route and as the body of a dashboard tab.
class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: CreatePropertyContent(),
      ),
    );
  }
}
