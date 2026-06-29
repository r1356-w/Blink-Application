import 'package:get/get.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';

enum NotificationsViewState { loading, error, success }

class NotificationsController extends GetxController {
  final NotificationsRepository _notificationsRepository;

  NotificationsController(this._notificationsRepository);

  final Rx<NotificationsViewState> viewState =
      NotificationsViewState.loading.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxnString errorMessage = RxnString();

  @override
  void onReady() {
    super.onReady();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    viewState.value = NotificationsViewState.loading;
    errorMessage.value = null;

    try {
      final result = await _notificationsRepository.getNotifications();
      notifications.assignAll(result);
      viewState.value = NotificationsViewState.success;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      viewState.value = NotificationsViewState.error;
    } catch (_) {
      errorMessage.value = 'unknown_error';
      viewState.value = NotificationsViewState.error;
    }
  }

  Future<void> onRetry() => fetchNotifications();
}
