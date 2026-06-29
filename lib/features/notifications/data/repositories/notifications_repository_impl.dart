import 'dart:io';

import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final rawList = await _remoteDataSource.getNotifications();
    return rawList.map(NotificationModel.fromJson).toList();
  }

  @override
  Future<void> registerDeviceToken({required String token}) {
    // 0 = Android, 1 = iOS per spec. Anything else (web/desktop, during
    // local dev) defaults to Android's value rather than sending a
    // nonsensical platform code.
    final platform = Platform.isIOS ? 1 : 0;

    return _remoteDataSource.registerDeviceToken(
      token: token,
      platform: platform,
    );
  }
}
