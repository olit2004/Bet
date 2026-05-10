import 'package:flutter/material.dart';
import '../views/create_property_content.dart';

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: CreatePropertyContent()));
  }
}
