import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/shimmer_box.dart';

/// Shown while `HomeController.viewState == HomeViewState.loading`.
/// Mirrors the eventual layout (a banner block, then a row of circular
/// store placeholders) so the transition to real content doesn't jump.
class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.md),
            child: ShimmerBox(
              width: double.infinity,
              height: 160,
              borderRadius: AppDimens.radiusMd,
            ),
          ),
          const SizedBox(height: AppDimens.lg),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.md),
            child: ShimmerBox(width: 140, height: 18),
          ),
          const SizedBox(height: AppDimens.sm),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              itemCount: 5,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimens.sm),
              itemBuilder: (_, __) => const Column(
                children: [
                  ShimmerBox(width: 72, height: 72, borderRadius: 36),
                  SizedBox(height: AppDimens.xs),
                  ShimmerBox(width: 64, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
