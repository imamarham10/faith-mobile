/// Successful response from `POST /auth/login`.
///
/// Shape: `{ accessToken, refreshToken, user: { id, email, roles }, expiresIn }`.
class AuthResponse {
  const AuthResponse({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
    this.roles = const [],
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final user = (json['user'] as Map<String, dynamic>?) ?? const {};
    final rawRoles = user['roles'];
    final roles = rawRoles is List
        ? rawRoles.map((r) => r.toString()).toList(growable: false)
        : const <String>[];

    return AuthResponse(
      userId: user['id']?.toString() ?? json['userId']?.toString() ?? '',
      email: user['email']?.toString() ?? json['email']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
      roles: roles,
    );
  }

  final String userId;
  final String email;
  final String accessToken;
  final String refreshToken;
  final int? expiresIn;
  final List<String> roles;
}
