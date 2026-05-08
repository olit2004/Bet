import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/my_listings_content.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MyListingsContent(
          onAddNewListing: () {
            context.push('/create-listing');
          },
        ),
      ),
    );
  }
}
