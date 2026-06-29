/// A single entry from `GET customer/notifications`.
///
/// Every field is parsed defensively: the backend is never trusted to
/// consistently send `id`, `title`, `body`, or `created_at`, so each one
/// falls back to a safe default rather than throwing during `fromJson`
/// and crashing the whole list.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime? createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt: _parseDate(json['created_at']),
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
