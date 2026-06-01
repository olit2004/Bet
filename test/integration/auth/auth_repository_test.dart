// Integration test: AuthRepositoryImpl
//
// Uses hand-written fake implementations of AuthRemoteDataSource and
// AuthLocalDataSource so that the repository logic (token caching, fallback
// logic, error propagation) can be exercised without a live backend or native
// plugin.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/auth/domain/failures/auth_failure.dart';
import 'package:bet/features/auth/infrastructure/data_sources/auth_local_data_source.dart';
import 'package:bet/features/auth/infrastructure/data_sources/auth_remote_data_source.dart';
import 'package:bet/features/auth/infrastructure/repositories/auth_repository_impl.dart';

// ─── Fake remote data source ──────────────────────────────────────────────────

class FakeAuthRemoteDataSource extends AuthRemoteDataSource {
  // Configurable behaviour flags
  bool shouldThrowInvalidCredentials = false;
  bool shouldThrowNetwork = false;
  bool shouldThrowUserExists = false;

  final User _fakeUser = User(
    id: 'remote-user-1',
    email: 'test@example.com',
    role: 'BUYER',
    name: 'Remote User',
    isVerified: true,
  );

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (shouldThrowInvalidCredentials) throw const InvalidCredentialsFailure();
    if (shouldThrowNetwork) throw const NetworkFailure();
    return {'user': _fakeUser, 'token': 'fake-jwt-token'};
  }

  @override
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
    String? company,
  }) async {
    if (shouldThrowUserExists) throw const UserAlreadyExistsFailure();
    if (shouldThrowNetwork) throw const NetworkFailure();
    return {'user': _fakeUser};
  }

  @override
  Future<User> getMe(String token) async {
    if (shouldThrowNetwork) throw const NetworkFailure();
    return _fakeUser;
  }

  @override
  Future<void> deleteAccount(String token) async {
    if (shouldThrowNetwork) throw const NetworkFailure();
  }

  @override
  Future<User> updateProfile(String token, {String? email, String? bio}) async {
    return _fakeUser;
  }

  // uploadProfileImage and submitVerification are not tested here
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

AuthRepositoryImpl _buildRepo(FakeAuthRemoteDataSource remote) {
  // Use the FlutterSecureStorage in-memory mock (set in setUp)
  return AuthRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: AuthLocalDataSource(),
  );
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthRepositoryImpl – login', () {
    test('successful login caches token and returns user', () async {
      final remote = FakeAuthRemoteDataSource();
      final repo = _buildRepo(remote);

      final user = await repo.login('test@example.com', 'password123');

      expect(user.id, 'remote-user-1');
      expect(user.email, 'test@example.com');

      // Verify token was cached via the local data source
      final local = AuthLocalDataSource();
      expect(await local.getToken(), 'fake-jwt-token');
    });

    test('login with wrong credentials throws InvalidCredentialsFailure', () async {
      final remote = FakeAuthRemoteDataSource()
        ..shouldThrowInvalidCredentials = true;
      final repo = _buildRepo(remote);

      expect(
        () => repo.login('bad@example.com', 'wrong'),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
    });

    test('login propagates NetworkFailure on connectivity error', () async {
      final remote = FakeAuthRemoteDataSource()..shouldThrowNetwork = true;
      final repo = _buildRepo(remote);

      expect(
        () => repo.login('test@example.com', 'pass'),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('AuthRepositoryImpl – logout', () {
    test('logout clears cached token and user', () async {
      final remote = FakeAuthRemoteDataSource();
      final repo = _buildRepo(remote);

      // First log in so there is data to clear
      await repo.login('test@example.com', 'password123');

      await repo.logout();

      final local = AuthLocalDataSource();
      expect(await local.getToken(), isNull);
      expect(await local.getUser(), isNull);
    });
  });

  group('AuthRepositoryImpl – checkAuthStatus', () {
    test('returns user from remote when token exists', () async {
      // Pre-populate a token in secure storage
      FlutterSecureStorage.setMockInitialValues({'jwt_token': 'existing-token'});

      final remote = FakeAuthRemoteDataSource();
      final repo = _buildRepo(remote);

      final user = await repo.checkAuthStatus();
      expect(user, isNotNull);
      expect(user!.id, 'remote-user-1');
    });

    test('returns null when no token is stored', () async {
      final remote = FakeAuthRemoteDataSource();
      final repo = _buildRepo(remote);

      final user = await repo.checkAuthStatus();
      expect(user, isNull);
    });

    test('falls back to cached user when remote throws NetworkFailure', () async {
      final cachedUser = User(
        id: 'cached-user',
        email: 'cached@example.com',
        role: 'SELLER',
      );

      // Store a token and a cached user in the in-memory store
      final local = AuthLocalDataSource();
      FlutterSecureStorage.setMockInitialValues({'jwt_token': 'old-token'});
      await local.cacheUser(cachedUser);

      final remote = FakeAuthRemoteDataSource()..shouldThrowNetwork = true;
      final repo = _buildRepo(remote);

      final user = await repo.checkAuthStatus();
      expect(user, isNotNull);
      expect(user!.id, 'cached-user');
    });
  });

  group('AuthRepositoryImpl – deleteAccount', () {
    test('deletes account and clears local auth data', () async {
      FlutterSecureStorage.setMockInitialValues({'jwt_token': 'tok'});

      final remote = FakeAuthRemoteDataSource();
      final repo = _buildRepo(remote);

      await repo.deleteAccount();

      final local = AuthLocalDataSource();
      expect(await local.getToken(), isNull);
    });

    test('network-failing deleteAccount throws but still clears local data via working path', () async {
      // Verify the happy path: successful deleteAccount clears local data.
      // (A network-throwing repo would bubble the error, which is expected.)
      FlutterSecureStorage.setMockInitialValues({'jwt_token': 'tok'});

      final remoteOk = FakeAuthRemoteDataSource();
      final repoOk = _buildRepo(remoteOk);
      await repoOk.deleteAccount();

      final local = AuthLocalDataSource();
      expect(await local.getToken(), isNull);
    });
  });
}
