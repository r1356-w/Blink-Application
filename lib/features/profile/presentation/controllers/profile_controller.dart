import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/localization/app_translations.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;
  final AuthService _authService;
  final LocalStorageService _storage;

  ProfileController(
    this._profileRepository,
    this._authService,
    this._storage,
  );

  final formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxBool isUpdating = false.obs;
  final RxBool isLoggingOut = false.obs;

  /// Mirrors the app's active locale so the UI can highlight the
  /// selected language chip reactively.
  final RxString activeLanguageCode = AppLocales.codeEn.obs;

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void onInit() {
    super.onInit();
    _hydrateFormFromCurrentUser();
    activeLanguageCode.value =
        Get.locale?.languageCode ?? _storage.localeCode;
  }

  void _hydrateFormFromCurrentUser() {
    final user = _authService.currentUser.value;
    firstNameController.text = user?.firstName ?? '';
    lastNameController.text = user?.lastName ?? '';
    emailController.text = user?.email ?? '';
  }

  String? validateFirstName(String? value) {
    if ((value ?? '').trim().isEmpty) return 'profile_required_field'.tr;
    return null;
  }

  String? validateLastName(String? value) {
    if ((value ?? '').trim().isEmpty) return 'profile_required_field'.tr;
    return null;
  }

  String? validateEmail(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty || !_emailRegex.hasMatch(trimmed)) {
      return 'profile_invalid_email'.tr;
    }
    return null;
  }

  /// Updates the backend, then hydrates the global, permanent
  /// `AuthService.currentUser` with the response — never just the
  /// controller's own local state — so every other screen reading the
  /// user (Home, etc.) reflects the change immediately.
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    if (isUpdating.value) return;

    isUpdating.value = true;
    try {
      final updatedUser = await _profileRepository.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
      );

      _authService.updateUser(updatedUser);

      Get.snackbar('profile_title'.tr, 'profile_update_success'.tr);
    } on AppException catch (e) {
      Get.snackbar('common_error_generic'.tr, e.message.tr);
    } finally {
      isUpdating.value = false;
    }
  }

  /// Flips between English and Arabic. `DioClient`'s
  /// `LocaleHeaderInterceptor` reads `Get.locale` fresh on every
  /// outgoing request, so there's nothing further to "notify" — the
  /// very next API call automatically carries the new
  /// `Accept-language` header. We still persist the choice so it
  /// survives an app restart.
  Future<void> toggleLanguage(String languageCode) async {
    if (activeLanguageCode.value == languageCode) return;

    final locale = languageCode == AppLocales.codeAr
        ? AppLocales.ar
        : AppLocales.en;

    await _storage.saveLocaleCode(languageCode);
    Get.updateLocale(locale);
    activeLanguageCode.value = languageCode;
  }

  /// Shows the confirmation dialog required before any destructive
  /// session action. Only on explicit confirmation does this proceed to
  /// [_performLogout].
  void confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: Text('profile_logout_confirm_title'.tr),
        content: Text('profile_logout_confirm_body'.tr),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('common_cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _performLogout();
            },
            child: Text('profile_logout'.tr),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;

    try {
      await _profileRepository.logout();
    } on AppException catch (_) {
      // The backend call invalidates the server-side session, but a
      // user who explicitly asked to log out should never be stuck
      // signed in locally just because this request failed (e.g. no
      // connectivity) — local session wipe below proceeds regardless.
    } finally {
      await _authService.clear();
      isLoggingOut.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
