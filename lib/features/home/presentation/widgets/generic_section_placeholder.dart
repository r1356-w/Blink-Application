import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/home_section_model.dart';

/// Rendered for any section whose `type.value` doesn't yet have a
/// dedicated layout (featured categories, featured products, promotion,
/// custom content, or any future/unknown type). Guarantees the app never
/// crashes or shows a blank gap just because a new section type shipped
/// on the backend before the app caught up.
class GenericSectionPlaceholder extends StatelessWidget {
  final HomeSectionModel section;

  const GenericSectionPlaceholder({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.widgets_outlined,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Text(
              section.title?.isNotEmpty == true
                  ? section.title!
                  : 'home_section_unsupported'.tr,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
