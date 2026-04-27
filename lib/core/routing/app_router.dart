import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Landing Screen Placeholder')),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Screen Placeholder')),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Signup Screen Placeholder')),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Forgot Password Placeholder')),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Screen Placeholder')),
        ),
      ),
    ],
  );
}
