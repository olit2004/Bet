class User {
  final String id;
  final String email;
  final String role;
  final String? name;
  final String? avatarUrl;
  final String? faydaId;
  final String? faydaImageUrl;
  final String? faydaStatus;
  final bool isVerified;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.avatarUrl,
    this.faydaId,
    this.faydaImageUrl,
    this.faydaStatus,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      faydaId: json['faydaId'] as String?,
      faydaImageUrl: json['faydaImageUrl'] as String?,
      faydaStatus: json['faydaStatus'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}
