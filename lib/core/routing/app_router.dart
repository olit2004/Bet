import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/features/auth/screens/landing_screen.dart';
import 'package:bet/features/auth/screens/signup_screen.dart';
import 'package:bet/features/auth/screens/login_screen.dart';
import 'package:bet/features/auth/screens/forgot_password_screen.dart';
import 'package:bet/features/property/presentation/screens/home_screen.dart';

/// Defines the global routing configuration using GoRouter.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found.'),
      ),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
