import 'package:shared_preferences/shared_preferences.dart';

/// Thin, testable wrapper around [SharedPreferences].
///
/// Nothing in the app should import `shared_preferences` directly outside
/// of this file — every read/write of local persistence goes through here
/// so the storage mechanism can be swapped later without touching callers.
class LocalStorageService {
  static const _keyAuthToken = 'auth_token';
  static const _keyLocaleCode = 'locale_code';
  static const _keyFcmToken = 'fcm_token';
  static const _keyOnboardingSeen = 'onboarding_seen';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ---- Auth token ----
  String? get authToken => _prefs.getString(_keyAuthToken);

  Future<bool> saveAuthToken(String token) =>
      _prefs.setString(_keyAuthToken, token);

  Future<bool> clearAuthToken() => _prefs.remove(_keyAuthToken);

  // ---- Locale ----
  String get localeCode => _prefs.getString(_keyLocaleCode) ?? 'en';

  Future<bool> saveLocaleCode(String code) =>
      _prefs.setString(_keyLocaleCode, code);

  // ---- FCM token cache ----
  String? get fcmToken => _prefs.getString(_keyFcmToken);

  Future<bool> saveFcmToken(String token) =>
      _prefs.setString(_keyFcmToken, token);

  // ---- Onboarding flag (example of a simple bool flag) ----
  bool get hasSeenOnboarding => _prefs.getBool(_keyOnboardingSeen) ?? false;

  Future<bool> setOnboardingSeen() =>
      _prefs.setBool(_keyOnboardingSeen, true);

  /// Wipes everything session-related. Used on logout.
  Future<void> clearSession() async {
    await clearAuthToken();
  }
}
