import 'package:flutter/material.dart';
import 'package:bet/core/routing/app_router.dart';
import 'package:bet/core/theme/app_theme.dart';

void main() {
  runApp(const BethApp());
}

class BethApp extends StatelessWidget {
  const BethApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
