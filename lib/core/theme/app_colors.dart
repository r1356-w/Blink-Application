import 'package:flutter/material.dart';

/// Every color used anywhere in the UI must come from here.
/// No widget should ever hardcode a `Color(0xFF...)` literal directly.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0F4FA8);
  static const Color secondary = Color(0xFFFF7A00);

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEDEEF1);

  static const Color success = Color(0xFF1FA855);
  static const Color error = Color(0xFFE0392B);
  static const Color warning = Color(0xFFF59E0B);

  static const Color shimmerBase = Color(0xFFE9EBEE);
  static const Color shimmerHighlight = Color(0xFFF5F6F8);
}
