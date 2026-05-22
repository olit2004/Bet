import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'cached_user';

  AuthLocalDataSource({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> cacheToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> cacheUser(User user) async {
    final userMap = {
      'id': user.id,
      'email': user.email,
      'role': user.role,
      'name': user.name,
    };
    await _storage.write(key: _userKey, value: jsonEncode(userMap));
  }

  Future<User?> getUser() async {
    final userString = await _storage.read(key: _userKey);
    if (userString != null) {
      return User.fromJson(jsonDecode(userString));
    }
    return null;
  }

  Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
