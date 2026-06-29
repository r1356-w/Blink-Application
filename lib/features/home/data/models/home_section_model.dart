import 'home_section_item_model.dart';
import 'section_type_model.dart';

/// A single home-screen section as returned by `GET home`.
///
/// `items` is returned already sorted by `sort_order` ascending —
/// sorting happens once, here at parse time, so every consumer
/// downstream (controller, widgets) can trust the order without
/// re-sorting defensively.
class HomeSectionModel {
  final int id;
  final int sortOrder;
  final String? title;
  final SectionTypeModel type;
  final List<HomeSectionItemModel> items;

  const HomeSectionModel({
    required this.id,
    required this.sortOrder,
    required this.type,
    required this.items,
    this.title,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(HomeSectionItemModel.fromJson)
            .toList()
        : <HomeSectionItemModel>[];

    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return HomeSectionModel(
      id: json['id'] as int? ?? -1,
      sortOrder: json['sort_order'] as int? ?? 0,
      title: json['title'] as String?,
      type: SectionTypeModel.fromJson(
        json['type'] as Map<String, dynamic>?,
      ),
      items: items,
    );
  }
}
