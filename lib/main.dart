import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'core/localization/app_translations.dart';
import 'core/network/dio_client.dart';
import 'core/routing/app_pages.dart';
import 'core/services/auth_service.dart';
import 'core/services/fcm_service.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSy...-mock",
          appId: "1:123456789:web:mock",
          messagingSenderId: "123456789",
          projectId: "blink-mock",
        ),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Firebase initialization timed out');
        },
      );
    } else {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Firebase initialization timed out');
        },
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // ---- App-wide permanent services, bootstrapped before runApp -------
  final storage = await LocalStorageService.init();
  Get.put<LocalStorageService>(storage, permanent: true);

  final authService = Get.put<AuthService>(AuthService(storage), permanent: true);

  Get.put<DioClient>(DioClient(authService), permanent: true);

  final fcmService = Get.put<FcmService>(FcmService(storage), permanent: true);
  try {
    await fcmService.init();
  } catch (e) {
    debugPrint('FCM initialization failed: $e');
  }

  // Restore whatever language the user last chose (defaults to 'en').
  final initialLocale = storage.localeCode == AppLocales.codeAr
      ? AppLocales.ar
      : AppLocales.en;

  runApp(BlinkApp(initialLocale: initialLocale));
}

class BlinkApp extends StatelessWidget {
  final Locale initialLocale;

  const BlinkApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: AppLocales.en,
      // Required for Get.updateLocale to actually flip text direction —
      // without these, Directionality has no RTL data for 'ar' and the
      // layout silently stays LTR regardless of the active locale.
      supportedLocales: const [AppLocales.en, AppLocales.ar],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
