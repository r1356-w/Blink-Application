import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

/// Covers both the "empty" and "error" states for one-shot screens.
/// Pass [onRetry] to show a retry button (typical for errors); omit it
/// for a plain empty state (typical for "no data yet").
class EmptyStateView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppDimens.xxl, color: AppColors.textSecondary),
            const SizedBox(height: AppDimens.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.lg),
              SizedBox(
                width: 160,
                child: AppButton(
                  label: retryLabel ?? 'common_retry'.tr,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
