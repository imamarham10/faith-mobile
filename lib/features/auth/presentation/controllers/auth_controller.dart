import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers.dart';
import '../../data/auth_repository.dart';
import '../../data/dtos/login_request.dart';
import '../../data/dtos/register_request.dart';
import '../../domain/auth_state.dart';

part 'auth_controller.g.dart';

/// Single source of truth for authentication state.
///
/// Persists tokens to secure storage; all other features should treat
/// `AuthAuthenticated` as the gate for protected requests.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    final storage = ref.watch(secureStorageProvider);
    final access = await storage.readAccessToken();
    if (access == null || access.isEmpty) {
      return const AuthUnauthenticated();
    }
    return AuthAuthenticated(accessToken: access);
  }

  /// Email + password sign in. Persists tokens and flips state on success.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.login(
        LoginRequest(email: email, password: password),
      );
      await ref
          .read(secureStorageProvider)
          .writeTokens(
            accessToken: res.accessToken,
            refreshToken: res.refreshToken,
          );
      state = AsyncValue.data(
        AuthAuthenticated(accessToken: res.accessToken, email: res.email),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Create a new account, then immediately sign the user in.
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(
        RegisterRequest(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        ),
      );
      await signIn(email: email, password: password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    final storage = ref.read(secureStorageProvider);
    final refresh = await storage.readRefreshToken();
    if (refresh != null && refresh.isNotEmpty) {
      await ref.read(authRepositoryProvider).logout(refresh);
    }
    await storage.clear();
    state = const AsyncValue.data(AuthUnauthenticated());
  }
}
