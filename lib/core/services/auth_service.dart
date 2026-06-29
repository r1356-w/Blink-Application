import 'package:get/get.dart';

import '../models/user_entity.dart';
import '../storage/local_storage_service.dart';

/// Permanent, app-wide singleton that tracks the current session.
///
/// Registered once in `main.dart` with `permanent: true` so it survives
/// for the lifetime of the app. The Dio auth interceptor and the route
/// guards both read from this — never from shared_preferences directly.
class AuthService extends GetxController {
  final LocalStorageService _storage;

  AuthService(this._storage);

  final RxBool isAuthenticated = false.obs;
  final RxnString token = RxnString();
  final Rxn<UserEntity> currentUser = Rxn<UserEntity>();

  @override
  void onInit() {
    super.onInit();
    final cached = _storage.authToken;
    if (cached != null && cached.isNotEmpty) {
      token.value = cached;
      isAuthenticated.value = true;
    }
  }

  /// Called once `auth/verify-otp` succeeds. Persists the token and
  /// keeps the parsed user in memory for the rest of the session.
  Future<void> login(String authToken, UserEntity user) async {
    await _storage.saveAuthToken(authToken);
    token.value = authToken;
    currentUser.value = user;
    isAuthenticated.value = true;
  }

  /// Called after a successful `auth/update-profile` response so every
  /// screen reading `currentUser` (Home, Profile, ...) reflects the edit
  /// immediately — the controller never mutates its own local copy of
  /// the user as a substitute for this.
  void updateUser(UserEntity user) {
    currentUser.value = user;
  }

  /// Wipes the session entirely. This is the canonical "log the user
  /// out" operation — called both from the explicit Profile logout flow
  /// and (via the [logout] alias below) from the 401 auto-logout path.
  Future<void> clear() async {
    await _storage.clearSession();
    token.value = null;
    currentUser.value = null;
    isAuthenticated.value = false;
  }

  /// Called by the Dio interceptor on a 401. Kept as a distinctly-named
  /// alias of [clear] so the interceptor's intent ("the server just
  /// rejected this session") stays readable at the call site.
  Future<void> logout() => clear();
}
