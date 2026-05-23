import '../entities/user.dart';

abstract class AuthRepository {
  /// Signs in a user with their email and password.
  /// Returns the authenticated [User].
  Future<User> login(String email, String password);

  /// Registers a new user with the provided details.
  /// Returns the authenticated [User].
  Future<User> register({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
    String? company,
  });

  /// Logs out the currently authenticated user, clearing any stored tokens.
  Future<void> logout();

  /// Deletes the currently authenticated user's account.
  Future<void> deleteAccount();
  
  /// Checks if the user is already authenticated (e.g. from secure storage)
  Future<User?> checkAuthStatus();

  /// Uploads a profile image for the authenticated user.
  Future<User> uploadProfileImage(dynamic imageFile);

  /// Submits Fayda ID verification for the authenticated user.
  Future<User> submitVerification(String faydaId, dynamic imageFile);
}
