import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'shimmer_box.dart';

/// Every remote image in the app should render through this widget —
/// it shows a [ShimmerBox] while loading and a neutral fallback icon if
/// the URL is null/empty or fails to load, so a missing image never
/// shows a raw red error box to the user.
class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppDimens.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallback(radius);
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => ShimmerBox(
          width: width,
          height: height,
          borderRadius: borderRadius,
        ),
        errorWidget: (_, __, ___) => _fallback(radius),
      ),
    );
  }

  Widget _fallback(BorderRadius radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: radius,
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}
