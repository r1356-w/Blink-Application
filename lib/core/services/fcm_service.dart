import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/local_storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

/// Wraps Firebase Cloud Messaging setup. Registered as a permanent
/// service in `main()`. Feature controllers (e.g. Auth) read `fcmToken`
/// from here when they need to send it to `customer/device-tokens` —
/// they never touch `firebase_messaging` directly.
class FcmService extends GetxController {
  final LocalStorageService _storage;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._storage);

  final RxnString fcmToken = RxnString();

  Future<void> init() async {
    if (kIsWeb) return;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('FCM token retrieval timed out');
        return null;
      },
    );
    if (token != null) {
      fcmToken.value = token;
      await _storage.saveFcmToken(token);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      _storage.saveFcmToken(newToken);
      // A refreshed token isn't automatically re-sent to the backend
      // here — `AuthController` (post-login) and `SplashController`
      // (bootstrap) are the two places that call
      // `NotificationsRepository.registerDeviceToken`, both of which
      // read this same `fcmToken` value when they run.
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    debugPrint('FCM foreground message: ${notification.title}');

    final isRtl = Get.locale?.languageCode == 'ar';

    Get.snackbar(
      notification.title ?? '',
      notification.body ?? '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.surface,
      colorText: AppColors.textPrimary,
      icon: const Icon(
        Icons.notifications_active_rounded,
        color: AppColors.primary,
      ),
      shouldIconPulse: false,
      borderRadius: AppDimens.radiusMd,
      margin: const EdgeInsets.all(AppDimens.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      boxShadows: const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOutCubic,
      // The icon/title/body row otherwise defaults to LTR regardless of
      // the active app locale — `Get.snackbar` builds its content in an
      // overlay that doesn't automatically inherit `GetMaterialApp`'s
      // Directionality, so it's set explicitly here.
      titleText: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Text(
          notification.title ?? '',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      messageText: Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Text(
          notification.body ?? '',
          style: AppTypography.bodyMedium,
        ),
      ),
    );
  }
}
