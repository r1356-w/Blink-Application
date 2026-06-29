/// Mirrors the backend's `type.value` enum for home sections.
/// Anything outside 0–5 (or a future addition) safely falls back to
/// [unknown] so new section types render via the generic placeholder
/// instead of crashing.
enum HomeSectionType {
  banner, // 0
  featuredCategories, // 1
  featuredStores, // 2
  featuredProducts, // 3
  promotion, // 4
  customContent, // 5
  unknown,
}

HomeSectionType _sectionTypeFromValue(int? value) {
  switch (value) {
    case 0:
      return HomeSectionType.banner;
    case 1:
      return HomeSectionType.featuredCategories;
    case 2:
      return HomeSectionType.featuredStores;
    case 3:
      return HomeSectionType.featuredProducts;
    case 4:
      return HomeSectionType.promotion;
    case 5:
      return HomeSectionType.customContent;
    default:
      return HomeSectionType.unknown;
  }
}

/// The `type` field on a home section is a nested object —
/// `{ "value": int, "label": "String" }` — never a primitive. This model
/// parses that shape directly so nothing upstream has to guess.
class SectionTypeModel {
  final int value;
  final String label;
  final HomeSectionType type;

  SectionTypeModel({required this.value, required this.label})
      : type = _sectionTypeFromValue(value);

  factory SectionTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SectionTypeModel(value: -1, label: '');
    }
    return SectionTypeModel(
      value: json['value'] as int? ?? -1,
      label: json['label'] as String? ?? '',
    );
  }
}
