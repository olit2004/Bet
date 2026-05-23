import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../infrastructure/data_sources/auth_local_data_source.dart';
import '../../infrastructure/data_sources/auth_remote_data_source.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';

// --- Dependency Injection Providers ---

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

// --- State Management ---

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthStateData {
  final AuthState status;
  final User? user;
  final String? errorMessage;

  AuthStateData({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthStateData copyWith({
    AuthState? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthStateData> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthStateData build() {
    // Start checking auth status asynchronously right after initialization
    Future.microtask(() => checkAuthStatus());
    return AuthStateData(status: AuthState.initial);
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthState.loading);
    try {
      final user = await _repository.checkAuthStatus();
      if (user != null) {
        state = state.copyWith(status: AuthState.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthState.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(status: AuthState.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthState.loading, errorMessage: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(status: AuthState.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthState.error, errorMessage: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
    String? company,
  }) async {
    state = state.copyWith(status: AuthState.loading, errorMessage: null);
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        role: role,
        name: name,
        phone: phone,
        company: company,
      );
      state = state.copyWith(status: AuthState.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthState.error, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthState.loading);
    await _repository.logout();
    // Use a fresh AuthStateData instead of copyWith so the user field is
    // genuinely null – copyWith(user: null) silently keeps the old value
    // because of the null ?? this.user fallback.
    state = AuthStateData(status: AuthState.unauthenticated);
  }

  Future<void> uploadProfileImage(dynamic imageFile) async {
    try {
      final updatedUser = await _repository.uploadProfileImage(imageFile);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> submitVerification(String faydaId, dynamic imageFile) async {
    try {
      final updatedUser = await _repository.submitVerification(faydaId, imageFile);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> updateProfile({String? email, String? bio}) async {
    try {
      final updatedUser = await _repository.updateProfile(email: email, bio: bio);
      state = state.copyWith(user: updatedUser);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(status: AuthState.loading);
    try {
      await _repository.deleteAccount();
      // Use a fresh AuthStateData so the user field is genuinely null.
      state = AuthStateData(status: AuthState.unauthenticated);
    } catch (e) {
      state = state.copyWith(status: AuthState.error, errorMessage: e.toString());
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthStateData>(() {
  return AuthNotifier();
});
