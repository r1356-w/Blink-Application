import 'package:flutter/material.dart';

import '../../data/models/home_section_model.dart';
import '../../data/models/section_type_model.dart';
import '../controllers/home_controller.dart';
import 'banner_slider.dart';
import 'featured_stores_section.dart';
import 'generic_section_placeholder.dart';

/// The single switch point between `section.type.type` and a concrete
/// widget. Adding a high-fidelity layout for a new section type later
/// means adding one case here — everything else (sorting, parsing,
/// fetching) already supports it.
class HomeSectionRenderer extends StatelessWidget {
  final HomeSectionModel section;
  final HomeController controller;

  const HomeSectionRenderer({
    super.key,
    required this.section,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (section.type.type) {
      case HomeSectionType.banner:
        return BannerSlider(items: section.items);

      case HomeSectionType.featuredStores:
        return FeaturedStoresSection(section: section, controller: controller);

      case HomeSectionType.featuredCategories:
      case HomeSectionType.featuredProducts:
      case HomeSectionType.promotion:
      case HomeSectionType.customContent:
      case HomeSectionType.unknown:
        return GenericSectionPlaceholder(section: section);
    }
  }
}
