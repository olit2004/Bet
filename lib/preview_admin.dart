import 'package:bet/features/admin/presentation/widgets/admin_routing.dart';
import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';

void main() {
  runApp(const AdminPreviewApp());
}

class AdminPreviewApp extends StatelessWidget {
  const AdminPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard Preview ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),

      home: const AdminHomeScreen(),
    );
  }
}
