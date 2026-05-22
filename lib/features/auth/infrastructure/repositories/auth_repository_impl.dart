import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<User> login(String email, String password) async {
    final result = await _remoteDataSource.login(email, password);
    final user = result['user'] as User;
    final token = result['token'] as String;

    await _localDataSource.cacheToken(token);
    await _localDataSource.cacheUser(user);

    return user;
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
    final result = await _remoteDataSource.register(
      email: email,
      password: password,
      role: role,
      name: name,
      phone: phone,
      company: company,
    );
    
    // Auto-login after registration is optional, but since our backend doesn't return a token on register,
    // we need to call login immediately after to get the token and cache it.
    return await login(email, password);
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearAuthData();
  }

  @override
  Future<void> deleteAccount() async {
    final token = await _localDataSource.getToken();
    if (token != null) {
      await _remoteDataSource.deleteAccount(token);
    }
    await _localDataSource.clearAuthData();
  }

  @override
  Future<User?> checkAuthStatus() async {
    final token = await _localDataSource.getToken();
    if (token == null) return null;
    
    return await _localDataSource.getUser();
  }
}
