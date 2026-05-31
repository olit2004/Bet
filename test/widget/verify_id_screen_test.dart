import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/profile/presentation/screens/verify_id_screen.dart';

void main() {
  group('VerifyIdScreen Widget Tests', () {
    Widget createWidgetUnderTest(User? user) {
      return ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(
            () => _MockAuthNotifier(
              AuthStateData(
                status: AuthState.authenticated,
                user: user,
              ),
            ),
          ),
        ],
        child: const MaterialApp(
          home: VerifyIdScreen(),
        ),
      );
    }

    testWidgets('shows Unverified status when user has not submitted', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'test@test.com',
        role: 'BUYER',
        name: 'Test',
        isVerified: false,
        faydaId: null,
        faydaStatus: 'PENDING', // Default from DB but no faydaId submitted
      );

      await tester.pumpWidget(createWidgetUnderTest(user));

      // Check status text
      expect(find.text('Unverified'), findsOneWidget);
      expect(find.text('Pending verification'), findsNothing);
      expect(find.text('Verified'), findsNothing);

      // Form should be visible
      expect(find.byType(Form), findsOneWidget);
      expect(find.text('Submit Verification'), findsOneWidget);
    });

    testWidgets('shows Pending status when user has submitted', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'test@test.com',
        role: 'BUYER',
        name: 'Test',
        isVerified: false,
        faydaId: 'FAN-12345',
        faydaStatus: 'PENDING',
      );

      await tester.pumpWidget(createWidgetUnderTest(user));

      // Check status text
      expect(find.text('Pending verification'), findsOneWidget);

      // Form should NOT be visible
      expect(find.byType(Form), findsNothing);
      expect(find.text('Submit Verification'), findsNothing);
    });

    testWidgets('shows Verified status', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'test@test.com',
        role: 'BUYER',
        name: 'Test',
        isVerified: true,
        faydaId: 'FAN-12345',
        faydaStatus: 'APPROVED',
      );

      await tester.pumpWidget(createWidgetUnderTest(user));

      // Check status text
      expect(find.text('Verified'), findsOneWidget);

      // Form should NOT be visible
      expect(find.byType(Form), findsNothing);
    });

    testWidgets('shows validation errors when submitting empty form', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'test@test.com',
        role: 'BUYER',
        name: 'Test',
        isVerified: false,
        faydaId: null,
      );

      await tester.pumpWidget(createWidgetUnderTest(user));

      // Tap submit button
      await tester.tap(find.widgetWithText(CustomButton, 'Submit Verification'));
      await tester.pumpAndSettle();

      // Check for FAN validation error
      expect(find.text('FAN Number is required'), findsOneWidget);
    });

    testWidgets('shows snackbar when FAN is entered but no image is picked', (WidgetTester tester) async {
      final user = User(
        id: '1',
        email: 'test@test.com',
        role: 'BUYER',
        name: 'Test',
        isVerified: false,
        faydaId: null,
      );

      await tester.pumpWidget(createWidgetUnderTest(user));

      // Enter FAN
      await tester.enterText(find.byType(TextFormField).first, 'FAN-12345');
      
      // Tap submit button
      await tester.tap(find.widgetWithText(CustomButton, 'Submit Verification'));
      await tester.pumpAndSettle();

      // Check for Snackbar
      expect(find.text('Please upload an image of your ID'), findsOneWidget);
    });
  });
}

class _MockAuthNotifier extends Notifier<AuthStateData> implements AuthNotifier {
  final AuthStateData initialState;

  _MockAuthNotifier(this.initialState);

  @override
  AuthStateData build() {
    return initialState;
  }

  @override
  Future<void> checkAuthStatus() async {}

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> register({required String email, required String password, required String role, required String name, required String phone, String? company}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<void> updateProfile({String? email, String? bio}) async {}

  @override
  Future<void> uploadProfileImage(dynamic imageFile) async {}

  @override
  Future<void> submitVerification(String faydaId, dynamic imageFile) async {}
}
