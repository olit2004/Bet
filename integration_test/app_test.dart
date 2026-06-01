// Flutter Integration Test: App End-to-End Flows
//
// These tests use the integration_test package to run the FULL app on a real
// device or emulator, verifying that widgets, navigation, and the Riverpod
// providers all work together as an integrated system.
//
// Run with:
//   flutter test integration_test/app_test.dart
// or on a specific device:
//   flutter test integration_test/app_test.dart -d linux

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bet/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test – Landing Screen', () {
    testWidgets('App starts and shows the landing screen with key elements',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // The landing screen should be visible (unauthenticated user lands here)
      // Check for the hero motto text
      expect(
        find.textContaining('WHERE HERITAGE MEETS MODERN OPPORTUNITY'),
        findsAny,
      );
    });

    testWidgets('LOGIN button is visible on landing screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('LOGIN'), findsOneWidget);
    });

    testWidgets('Get Started button is visible on landing screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Get Started'), findsOneWidget);
    });
  });

  group('Integration Test – Navigation: Landing → Login', () {
    testWidgets('Tapping LOGIN navigates to the Login screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap the LOGIN button in the app bar
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Login screen should now be visible
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to your private portfolio.'),
        findsOneWidget,
      );
    });

    testWidgets('Login screen shows Email and Password fields',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextFormField, 'Email address'), findsAny);
      // Password field may use hint text
      expect(find.widgetWithText(TextFormField, 'Password'), findsAny);
    });

    testWidgets('Login screen shows Sign In button', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Login form validates empty fields on submit',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap Sign In without entering anything
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Validation error should appear
      expect(
        find.text('Please enter your email address'),
        findsOneWidget,
      );
    });

    testWidgets('Login form validates invalid email format',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter invalid email (no @)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'notanemail',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(
        find.text('Please enter a valid email address'),
        findsOneWidget,
      );
    });

    testWidgets('Login form validates short password', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'short',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(
        find.text('Password must be at least 8 characters long'),
        findsOneWidget,
      );
    });
  });

  group('Integration Test – Navigation: Landing → Sign Up', () {
    testWidgets('Tapping Get Started navigates to Sign Up screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Sign up screen should be visible — look for its distinctive text
      expect(
        find.textContaining('Create'),
        findsAny,
      );
    });
  });

  group('Integration Test – Login Screen: Role Toggle', () {
    testWidgets('Role toggle shows Buyer/Renter and Seller/Landlord options',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Buyer/Renter'), findsOneWidget);
      expect(find.text('Seller/Landlord'), findsOneWidget);
    });

    testWidgets('Tapping Seller/Landlord toggle switches role selection',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.text('Seller/Landlord'));
      await tester.pumpAndSettle();

      // Both labels should still be present
      expect(find.text('Seller/Landlord'), findsOneWidget);
      expect(find.text('Buyer/Renter'), findsOneWidget);
    });
  });

  group('Integration Test – Login Screen: Password Visibility Toggle', () {
    testWidgets('Password visibility icon toggles obscure state',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Initially, visibility_outlined icon is shown (password hidden)
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap the icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      // Now visibility_off_outlined should be shown (password visible)
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });
}
