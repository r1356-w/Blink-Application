import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/shimmer_box.dart';

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimens.sm),
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimens.md),
        child: ShimmerBox(
          width: double.infinity,
          height: 76,
          borderRadius: AppDimens.radiusMd,
        ),
      ),
    );
  }
}
