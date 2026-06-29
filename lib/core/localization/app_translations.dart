import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ar_sa.dart';
import 'en_us.dart';

class AppLocales {
  AppLocales._();

  static const Locale en = Locale('en', 'US');
  static const Locale ar = Locale('ar', 'SA');

  static const String codeEn = 'en';
  static const String codeAr = 'ar';
}

/// Wires the EN/AR maps into GetX's translation system.
/// Used as `translations: AppTranslations()` on `GetMaterialApp`.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        AppLocales.codeEn: enUS,
        AppLocales.codeAr: arSA,
      };
}
