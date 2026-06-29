import '../../../../core/network/image_url_resolver.dart';
import 'link_data_model.dart';

/// A single entry inside a section's `items` array.
///
/// Banners carry their own `image_url`; featured-store items carry a
/// `link_data` object instead (with the store's own `logo_url` and the
/// id needed for navigation). Both shapes are represented here so one
/// model serves every section type, with [linkData] nullable for
/// sections that don't have one.
class HomeSectionItemModel {
  final int id;
  final int sortOrder;
  final String? title;
  final String? imageUrl;
  final LinkDataModel? linkData;

  const HomeSectionItemModel({
    required this.id,
    required this.sortOrder,
    this.title,
    this.imageUrl,
    this.linkData,
  });

  factory HomeSectionItemModel.fromJson(Map<String, dynamic> json) {
    final rawLinkData = json['link_data'];

    return HomeSectionItemModel(
      id: json['id'] as int? ?? -1,
      sortOrder: json['sort_order'] as int? ?? 0,
      title: json['title'] as String?,
      imageUrl: ImageUrlResolver.resolve(json['image_url'] as String?),
      linkData: rawLinkData is Map<String, dynamic>
          ? LinkDataModel.fromJson(rawLinkData)
          : null,
    );
  }
}
