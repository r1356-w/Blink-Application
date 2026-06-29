import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/home_section_model.dart';
import '../controllers/home_controller.dart';
import 'store_card.dart';

/// High-fidelity layout for `type.value == 2` (featured stores) sections.
class FeaturedStoresSection extends StatelessWidget {
  final HomeSectionModel section;
  final HomeController controller;

  const FeaturedStoresSection({
    super.key,
    required this.section,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (section.items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
            child: Text(
              section.title?.isNotEmpty == true
                  ? section.title!
                  : 'home_featured_stores'.tr,
              style: AppTypography.h3,
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              itemCount: section.items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimens.sm),
              itemBuilder: (context, index) {
                final item = section.items[index];
                return StoreCard(
                  item: item,
                  onTap: () => controller.onStoreItemTap(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
