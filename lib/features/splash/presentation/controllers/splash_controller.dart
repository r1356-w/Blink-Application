import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../notifications/domain/repositories/notifications_repository.dart';

/// Splash exists purely to decide where to send the user once the app
/// services (storage, auth session) are ready — it owns no business logic
/// beyond that routing decision (plus the device-token re-registration
/// nudge below, which is a side-effect of "we already have a session",
/// not a routing concern itself).
class SplashController extends GetxController {
  final AuthService _authService;
  final FcmService _fcmService;
  final NotificationsRepository _notificationsRepository;

  SplashController(
    this._authService,
    this._fcmService,
    this._notificationsRepository,
  );

  @override
  void onReady() {
    super.onReady();
    _resolveInitialRoute();
  }

  Future<void> _resolveInitialRoute() async {
    // Small, deliberate delay so the splash branding is actually visible —
    // not a loading hack.
    await Future.delayed(const Duration(milliseconds: 600));

    if (_authService.isAuthenticated.value) {
      // Bootstrap-time device-token registration: if the app already
      // had a stored session when it launched, the token (which FCM
      // may have refreshed since the last app run) is re-synced with
      // the backend. Fire-and-forget — must never delay routing.
      final notificationToken = _fcmService.fcmToken.value;
      if (notificationToken != null && notificationToken.isNotEmpty) {
        unawaited(
          _notificationsRepository
              .registerDeviceToken(token: notificationToken)
              .catchError((_) {}),
        );
      }

      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
