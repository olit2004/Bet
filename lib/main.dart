import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bet/core/routing/app_router.dart';
import 'package:bet/core/theme/app_theme.dart';

void main() {
  runApp(const BethApp());
}

class BethApp extends StatelessWidget {
  const BethApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your providers here as you implement them
      ],
      child: MaterialApp.router(
        title: 'Bet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
