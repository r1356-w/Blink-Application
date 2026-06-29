import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/home_section_item_model.dart';

/// High-fidelity layout for `type.value == 0` (banner) sections.
///
/// Items are already sorted by `sort_order` by the time they reach here.
/// Banners are presentational only — they don't carry a `link_data`
/// navigation target in this version of the API, so this widget has no
/// tap behavior to wire up.
class BannerSlider extends StatefulWidget {
  final List<HomeSectionItemModel> items;

  const BannerSlider({super.key, required this.items});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final banner = widget.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.md,
                ),
                child: AppNetworkImage(
                  imageUrl: banner.imageUrl,
                  width: double.infinity,
                  height: 160,
                  borderRadius: AppDimens.radiusMd,
                ),
              );
            },
          ),
        ),
        if (widget.items.length > 1) ...[
          const SizedBox(height: AppDimens.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
