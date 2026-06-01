// Integration test: AuthLocalDataSource
//
// Uses the built-in FlutterSecureStorage.setMockInitialValues() test hook to
// replace the underlying platform channel with an in-memory store, so the
// test runs on any platform without native plugins.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auth/domain/entities/user.dart';
import 'package:bet/features/auth/infrastructure/data_sources/auth_local_data_source.dart';

void main() {
  // Initialise the in-memory secure storage before every test.
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AuthLocalDataSource – token management', () {
    test('cacheToken stores a token that getToken can retrieve', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheToken('my-jwt-token');
      expect(await ds.getToken(), 'my-jwt-token');
    });

    test('getToken returns null when no token has been stored', () async {
      final ds = AuthLocalDataSource();
      expect(await ds.getToken(), isNull);
    });

    test('clearAuthData removes the stored token', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheToken('to-be-deleted');
      await ds.clearAuthData();
      expect(await ds.getToken(), isNull);
    });
  });

  group('AuthLocalDataSource – user caching', () {
    final sampleUser = User(
      id: 'u-1',
      email: 'test@example.com',
      role: 'BUYER',
      name: 'Test User',
      isVerified: true,
    );

    test('cacheUser persists user fields that getUser retrieves', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheUser(sampleUser);

      final retrieved = await ds.getUser();

      expect(retrieved, isNotNull);
      expect(retrieved!.id, sampleUser.id);
      expect(retrieved.email, sampleUser.email);
      expect(retrieved.role, sampleUser.role);
      expect(retrieved.name, sampleUser.name);
      expect(retrieved.isVerified, sampleUser.isVerified);
    });

    test('getUser returns null when no user has been cached', () async {
      final ds = AuthLocalDataSource();
      expect(await ds.getUser(), isNull);
    });

    test('cacheUser overwrites a previously cached user', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheUser(sampleUser);

      final updatedUser = User(
        id: 'u-1',
        email: 'updated@example.com',
        role: 'SELLER',
        name: 'Updated Name',
        isVerified: false,
      );
      await ds.cacheUser(updatedUser);

      final retrieved = await ds.getUser();
      expect(retrieved!.email, 'updated@example.com');
      expect(retrieved.role, 'SELLER');
    });

    test('clearAuthData removes the cached user', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheUser(sampleUser);
      await ds.clearAuthData();
      expect(await ds.getUser(), isNull);
    });
  });

  group('AuthLocalDataSource – combined token + user teardown', () {
    test('clearAuthData removes both token and user simultaneously', () async {
      final ds = AuthLocalDataSource();
      await ds.cacheToken('tok');
      await ds.cacheUser(
        User(id: 'u', email: 'e@e.com', role: 'BUYER'),
      );

      await ds.clearAuthData();

      expect(await ds.getToken(), isNull);
      expect(await ds.getUser(), isNull);
    });
  });
}
