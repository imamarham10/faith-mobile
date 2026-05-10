/// Sealed authentication state for the entire app.
///
/// `Initializing` is the boot state we sit in while reading secure storage.
/// `Unauthenticated` means we have no valid token. `Authenticated` carries the
/// access token; the refresh token stays in secure storage only.
sealed class AuthState {
  const AuthState();
}

class AuthInitializing extends AuthState {
  const AuthInitializing();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.accessToken, this.email});

  final String accessToken;
  final String? email;
}
