import '../../data/models/notification_model.dart';

abstract class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications();

  /// Registers (or re-registers) this device's current FCM token with
  /// the backend. Platform detection (`0` = Android, `1` = iOS) is an
  /// implementation detail of the data layer — callers only supply the
  /// token itself.
  Future<void> registerDeviceToken({required String token});
}
