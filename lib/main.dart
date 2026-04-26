import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
// Import other providers as they are created
// import 'features/auth/presentation/providers/auth_provider.dart';

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
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => PropertyProvider()),
      ],
      child: MaterialApp.router(
        title: 'Beth',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme, // Assuming Member 1 implements this
        routerConfig: AppRouter.router, // Assuming Member 1 implements this
      ),
    );
  }
}
