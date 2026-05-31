// Unit Tests: AuthNotifier (Riverpod Provider)
//
// Tests the AuthNotifier Riverpod state machine in isolation by overriding
// the authRepositoryProvider with a hand-written fake.  No real network
// or platform channels are involved – pure in-memory state changes.
//
// This is the pattern recommended by the Riverpod testing docs:
//   https://riverpod.dev/docs/cookbooks/testing
//
// Run tests:
//   flutter test test/unit/auth_notifier_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/auth/domain/failures/auth_failure.dart';
import 'package:bet/features/auth/domain/repositories/auth_repository.dart';
import 'package:bet/features/auth/application/providers/auth_provider.dart';

// ── Fake AuthRepository ──────────────────────────────────────────────────────

class FakeAuthRepository implements AuthRepository {
  // Behaviour configuration
  bool shouldThrowInvalidCredentials = false;
  bool shouldThrowNetwork = false;
  bool shouldThrowUserExists = false;

  User? storedUser;
  String? storedToken;

  final User _fakeUser = User(
    id: 'user-1',
    email: 'test@example.com',
    role: 'BUYER',
    name: 'Test User',
    isVerified: false,
  );

  @override
  Future<User> login(String email, String password) async {
    if (shouldThrowInvalidCredentials) throw const InvalidCredentialsFailure();
    if (shouldThrowNetwork) throw const NetworkFailure();
    storedUser = _fakeUser;
    return _fakeUser;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
    String? company,
  }) async {
    if (shouldThrowUserExists) throw const UserAlreadyExistsFailure();
    if (shouldThrowNetwork) throw const NetworkFailure();
    storedUser = _fakeUser;
    return _fakeUser;
  }

  @override
  Future<void> logout() async {
    storedUser = null;
    storedToken = null;
  }

  @override
  Future<void> deleteAccount() async {
    if (shouldThrowNetwork) throw const NetworkFailure();
    storedUser = null;
  }

  @override
  Future<User?> checkAuthStatus() async {
    if (shouldThrowNetwork) return storedUser; // offline fallback
    return storedUser;
  }

  @override
  Future<User> uploadProfileImage(dynamic imageFile) async => _fakeUser;

  @override
  Future<User> submitVerification(String faydaId, dynamic imageFile) async {
    final updated = User(
      id: _fakeUser.id,
      email: _fakeUser.email,
      role: _fakeUser.role,
      name: _fakeUser.name,
      faydaId: faydaId,
      faydaStatus: 'PENDING',
      isVerified: _fakeUser.isVerified,
    );
    storedUser = updated;
    return updated;
  }

  @override
  Future<User> updateProfile({String? email, String? bio}) async {
    final updated = User(
      id: _fakeUser.id,
      email: email ?? _fakeUser.email,
      role: _fakeUser.role,
      name: _fakeUser.name,
      bio: bio,
      isVerified: _fakeUser.isVerified,
    );
    storedUser = updated;
    return updated;
  }
}

// ── Helper ────────────────────────────────────────────────────────────────────

/// Creates a [ProviderContainer] with [FakeAuthRepository] injected,
/// skipping the async checkAuthStatus that fires in build().
ProviderContainer buildContainer(FakeAuthRepository repo) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // Initial state
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – initial state', () {
    test('starts in AuthState.initial synchronously before any async work', () {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      // build() returns AuthState.initial synchronously; the checkAuthStatus
      // microtask hasn't fired yet because no await has occurred.
      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.initial);
      expect(state.user, isNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // login()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – login', () {
    test('successful login sets status to authenticated with correct user', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('test@example.com', 'password123');

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.authenticated);
      expect(state.user, isNotNull);
      expect(state.user!.email, 'test@example.com');
      expect(state.user!.id, 'user-1');
    });

    test('invalid credentials sets status to error with message', () async {
      final repo = FakeAuthRepository()..shouldThrowInvalidCredentials = true;
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('bad@example.com', 'wrong');

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.error);
      expect(state.errorMessage, isNotNull);
    });

    test('network failure sets status to error', () async {
      final repo = FakeAuthRepository()..shouldThrowNetwork = true;
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('user@example.com', 'pass');

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.error);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // register()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – register', () {
    test('successful register sets status to authenticated', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).register(
            email: 'new@example.com',
            password: 'secret123',
            role: 'BUYER',
            name: 'New User',
            phone: '0911000000',
          );

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.authenticated);
      expect(state.user, isNotNull);
    });

    test('existing user throws UserAlreadyExistsFailure → error state', () async {
      final repo = FakeAuthRepository()..shouldThrowUserExists = true;
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).register(
            email: 'existing@example.com',
            password: 'pass',
            role: 'BUYER',
            name: 'Dup',
            phone: '0900000000',
          );

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.error);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // logout()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – logout', () {
    test('logout after login clears user and sets unauthenticated', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      // Log in first
      await container
          .read(authNotifierProvider.notifier)
          .login('test@example.com', 'password123');
      expect(container.read(authNotifierProvider).status,
          AuthState.authenticated);

      // Then log out
      await container.read(authNotifierProvider.notifier).logout();

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.unauthenticated);
      expect(state.user, isNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // deleteAccount()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – deleteAccount', () {
    test('deleteAccount sets state to unauthenticated on success', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('test@example.com', 'password123');

      await container.read(authNotifierProvider.notifier).deleteAccount();

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.unauthenticated);
      expect(state.user, isNull);
    });

    test('deleteAccount sets error state when network fails', () async {
      final repo = FakeAuthRepository()..shouldThrowNetwork = true;
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(authNotifierProvider.notifier).deleteAccount();

      final state = container.read(authNotifierProvider);
      expect(state.status, AuthState.error);
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // updateProfile()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – updateProfile', () {
    test('updateProfile updates user bio in state', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('test@example.com', 'password123');

      await container
          .read(authNotifierProvider.notifier)
          .updateProfile(bio: 'My new bio.');

      final state = container.read(authNotifierProvider);
      expect(state.user?.bio, 'My new bio.');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // submitVerification()
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthNotifier – submitVerification', () {
    test('submitVerification updates user faydaId and status in state', () async {
      final repo = FakeAuthRepository();
      final container = buildContainer(repo);
      addTearDown(container.dispose);

      await container
          .read(authNotifierProvider.notifier)
          .login('test@example.com', 'password123');

      await container
          .read(authNotifierProvider.notifier)
          .submitVerification('FAN-123', null);

      final state = container.read(authNotifierProvider);
      expect(state.user?.faydaId, 'FAN-123');
      expect(state.user?.faydaStatus, 'PENDING');
    });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // AuthStateData.copyWith
  // ──────────────────────────────────────────────────────────────────────────
  group('AuthStateData – copyWith', () {
    test('copyWith preserves existing fields when nothing overridden', () {
      final original = AuthStateData(
        status: AuthState.authenticated,
        user: User(id: 'u', email: 'e@e.com', role: 'BUYER'),
        errorMessage: null,
      );
      final copy = original.copyWith();
      expect(copy.status, original.status);
      expect(copy.user?.id, original.user?.id);
    });

    test('copyWith overrides status only', () {
      final original = AuthStateData(status: AuthState.loading);
      final copy = original.copyWith(status: AuthState.unauthenticated);
      expect(copy.status, AuthState.unauthenticated);
    });

    test('copyWith overrides errorMessage', () {
      final original = AuthStateData(status: AuthState.error);
      final copy = original.copyWith(errorMessage: 'Oops');
      expect(copy.errorMessage, 'Oops');
    });
  });
}
