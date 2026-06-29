import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/shimmer_box.dart';

/// Mirrors the store header (cover + logo + name) while
/// `StoreViewState == loading`.
class StoreHeaderShimmer extends StatelessWidget {
  const StoreHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppDimens.md),
      child: Row(
        children: [
          ShimmerBox(width: 64, height: 64, borderRadius: 32),
          SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 140, height: 18),
                SizedBox(height: AppDimens.xs),
                ShimmerBox(width: 90, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mirrors the product grid while the initial page of products loads.
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimens.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimens.sm,
        crossAxisSpacing: AppDimens.sm,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, __) => const ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: AppDimens.radiusMd,
      ),
    );
  }
}
