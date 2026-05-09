import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bet/core/routing/app_router.dart';
import 'package:bet/core/theme/app_theme.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/core/property/repositories/property_repository_impl.dart';

import 'package:bet/core/providers/navigation_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => PropertyProvider(
            repository: PropertyRepositoryImpl(),
          ),
        ),
      ],
      child: const BethApp(),
    ),
  );
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
