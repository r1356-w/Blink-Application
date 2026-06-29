import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/home_section_item_model.dart';

/// High-fidelity layout for a single item inside a `type.value == 2`
/// (featured stores) section. The store's logo and name come from
/// `link_data`, not the item's own fields — see `HomeController.
/// onStoreItemTap` for why the id specifically must be read from there.
class StoreCard extends StatelessWidget {
  final HomeSectionItemModel item;
  final VoidCallback onTap;

  const StoreCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final linkData = item.linkData;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 96,
        child: Column(
          children: [
            AppNetworkImage(
              imageUrl: linkData?.logoUrl,
              width: 72,
              height: 72,
              borderRadius: 36,
            ),
            const SizedBox(height: AppDimens.xs),
            Text(
              linkData?.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
