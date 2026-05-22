class AuthFailure implements Exception {
  final String message;
  
  const AuthFailure([this.message = 'An unexpected authentication error occurred.']);

  @override
  String toString() => message;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('Invalid email or password.');
}

class UserAlreadyExistsFailure extends AuthFailure {
  const UserAlreadyExistsFailure() : super('A user with this email already exists.');
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('Please check your internet connection.');
}
