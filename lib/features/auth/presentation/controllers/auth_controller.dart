import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../notifications/domain/repositories/notifications_repository.dart';
import '../../domain/repositories/auth_repository.dart';

/// Drives both `LoginScreen` and `OtpScreen`. A single instance is
/// shared across the two screens (registered once per the Auth route
/// group via `AuthBinding`) so the phone number entered on Login is
/// still available when `verifyOtp()` runs on the OTP screen.
class AuthController extends GetxController {
  final AuthRepository _authRepository;
  final AuthService _authService;
  final FcmService _fcmService;
  final NotificationsRepository _notificationsRepository;

  AuthController(
    this._authRepository,
    this._authService,
    this._fcmService,
    this._notificationsRepository,
  );

  // ---- Form state ----
  final loginFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  /// Holds the phone number once OTP has been requested, so the OTP
  /// screen (and a resend tap) always knows which number it's verifying.
  final RxString phoneNumber = ''.obs;

  final RxBool isRequestingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;

  static final RegExp _phoneRegex = RegExp(r'^[0-9]{8,15}$');
  static final RegExp _otpRegex = RegExp(r'^\d{5}$');

  String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || !_phoneRegex.hasMatch(trimmed)) {
      return 'auth_invalid_phone'.tr;
    }
    return null;
  }

  String? validateOtp(String? value) {
    final trimmed = value?.trim() ?? '';
    if (!_otpRegex.hasMatch(trimmed)) {
      return 'auth_invalid_otp'.tr;
    }
    return null;
  }

  /// Step 1: request an OTP for the entered phone number.
  Future<void> requestOtp() async {
    if (!loginFormKey.currentState!.validate()) return;
    if (isRequestingOtp.value) return;

    final enteredPhone = phoneController.text.trim();

    isRequestingOtp.value = true;
    try {
      await _authRepository.requestOtp(phoneNumber: enteredPhone);
      phoneNumber.value = enteredPhone;
      otpController.clear();
      Get.toNamed(AppRoutes.otp);
    } on AppException catch (e) {
      Get.snackbar('common_error_generic'.tr, e.message.tr);
    } finally {
      isRequestingOtp.value = false;
    }
  }

  /// Step 2: verify the OTP, hydrate the global session, and land on Home.
  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;
    if (isVerifyingOtp.value) return;

    isVerifyingOtp.value = true;
    try {
      final notificationToken = _fcmService.fcmToken.value;

      final result = await _authRepository.verifyOtp(
        phoneNumber: phoneNumber.value,
        otp: otpController.text.trim(),
        notificationToken: notificationToken,
      );

      await _authService.login(result.token, result.user);

      // Fire-and-forget: a failure to register this device's push
      // token should never block the user from reaching Home after a
      // successful login.
      if (notificationToken != null && notificationToken.isNotEmpty) {
        unawaited(
          _notificationsRepository
              .registerDeviceToken(token: notificationToken)
              .catchError((_) {}),
        );
      }

      Get.offAllNamed(AppRoutes.home);
    } on AppException catch (e) {
      Get.snackbar('common_error_generic'.tr, e.message.tr);
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  /// Re-triggers `request-otp` for the same phone number from the OTP
  /// screen's "resend" action — distinct from `requestOtp()` in that it
  /// doesn't re-validate a form or navigate anywhere on success.
  Future<void> resendOtp() async {
    if (isRequestingOtp.value) return;

    isRequestingOtp.value = true;
    try {
      await _authRepository.requestOtp(phoneNumber: phoneNumber.value);
      Get.snackbar('auth_send_otp'.tr, phoneNumber.value);
    } on AppException catch (e) {
      Get.snackbar('common_error_generic'.tr, e.message.tr);
    } finally {
      isRequestingOtp.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
