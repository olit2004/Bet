// Integration test: User entity
//
// Verifies that User.fromJson correctly maps all fields,
// handles optional nulls, and applies default values.

import 'package:flutter_test/flutter_test.dart';
import 'package:bet/features/auth/domain/entities/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses a complete JSON object correctly', () {
      final json = {
        'id': 'user-123',
        'email': 'alice@example.com',
        'role': 'SELLER',
        'name': 'Alice Kebede',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'faydaId': 'FYD-001',
        'faydaImageUrl': 'https://example.com/fayda.jpg',
        'faydaStatus': 'APPROVED',
        'isVerified': true,
        'createdAt': '2024-01-15T10:30:00.000Z',
        'bio': 'Real-estate investor.',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user-123');
      expect(user.email, 'alice@example.com');
      expect(user.role, 'SELLER');
      expect(user.name, 'Alice Kebede');
      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
      expect(user.faydaId, 'FYD-001');
      expect(user.faydaImageUrl, 'https://example.com/fayda.jpg');
      expect(user.faydaStatus, 'APPROVED');
      expect(user.isVerified, isTrue);
      expect(user.createdAt, DateTime.parse('2024-01-15T10:30:00.000Z'));
      expect(user.bio, 'Real-estate investor.');
    });

    test('uses defaults for optional / nullable fields', () {
      final json = {
        'id': 'user-456',
        'email': 'bob@example.com',
        'role': 'BUYER',
        // name, avatarUrl, faydaId, faydaImageUrl, faydaStatus, createdAt, bio omitted
        // isVerified omitted → should default to false
      };

      final user = User.fromJson(json);

      expect(user.id, 'user-456');
      expect(user.email, 'bob@example.com');
      expect(user.role, 'BUYER');
      expect(user.name, isNull);
      expect(user.avatarUrl, isNull);
      expect(user.faydaId, isNull);
      expect(user.faydaImageUrl, isNull);
      expect(user.faydaStatus, isNull);
      expect(user.isVerified, isFalse); // default
      expect(user.createdAt, isNull);
      expect(user.bio, isNull);
    });

    test('handles isVerified explicitly set to false', () {
      final json = {
        'id': 'user-789',
        'email': 'carol@example.com',
        'role': 'BUYER',
        'isVerified': false,
      };

      final user = User.fromJson(json);
      expect(user.isVerified, isFalse);
    });

    test('parses createdAt as null when field is null in JSON', () {
      final json = {
        'id': 'user-000',
        'email': 'dave@example.com',
        'role': 'GUEST',
        'createdAt': null,
      };

      final user = User.fromJson(json);
      expect(user.createdAt, isNull);
    });
  });
}
