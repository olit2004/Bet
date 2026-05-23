import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/core/routing/app_router.dart';
import 'package:bet/core/theme/app_theme.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/core/property/repositories/property_repository_impl.dart';

import 'package:bet/core/providers/navigation_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(
            create: (_) =>
                PropertyProvider(repository: PropertyRepositoryImpl()),
          ),
        ],
        child: const BethApp(),
      ),
    ),
  );
}

class BethApp extends ConsumerWidget {
  const BethApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Bet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}


