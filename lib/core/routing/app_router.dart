import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';
import 'package:bet/features/auth/screens/landing_screen.dart';
import 'package:bet/features/auth/screens/signup_screen.dart';
import 'package:bet/features/auth/screens/login_screen.dart';
import 'package:bet/features/auth/screens/forgot_password_screen.dart';
import 'package:bet/features/admin/presentation/widgets/admin_routing.dart';
import 'package:bet/features/buyer/buyer_routes.dart';
import 'package:bet/features/seller/seller_routes.dart';
import 'package:bet/features/profile/presentation/screens/settings_screen.dart';
import 'package:bet/features/notification/presentation/screens/notifications_screen.dart';
import 'package:bet/core/widgets/main_wrapper.dart';

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref) {
    _subscription = ref.listen<AuthStateData>(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AuthStateData> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  
  ref.onDispose(() {
    refreshNotifier.dispose();
  });

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isAuth = authState.status == AuthState.authenticated;
      final isLoggingIn = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/signup' || 
                          state.matchedLocation == '/';

      if (authState.status == AuthState.loading || authState.status == AuthState.initial) {
        return null; // Don't redirect while checking status
      }

      if (!isAuth && !isLoggingIn) return '/';
      
      if (isAuth && isLoggingIn) {
        if (authState.user?.role == 'ADMIN') return '/admin-dashboard';
        if (authState.user?.role == 'SELLER') return '/seller-dashboard';
        return '/home';
      }
      
      return null;
    },
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found.'))),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const MainWrapper()),
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      ...BuyerRoutes.routes,
      ...SellerRoutes.routes,
    ],
  );
});
