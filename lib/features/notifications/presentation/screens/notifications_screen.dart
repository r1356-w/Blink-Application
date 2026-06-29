import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notifications_shimmer.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('notifications_title'.tr)),
      body: SafeArea(
        child: Obx(() {
          switch (controller.viewState.value) {
            case NotificationsViewState.loading:
              return const NotificationsShimmer();

            case NotificationsViewState.error:
              return EmptyStateView(
                icon: Icons.cloud_off_outlined,
                message:
                    (controller.errorMessage.value ?? 'unknown_error').tr,
                onRetry: controller.onRetry,
              );

            case NotificationsViewState.success:
              if (controller.notifications.isEmpty) {
                return EmptyStateView(
                  icon: Icons.notifications_none_outlined,
                  message: 'notifications_empty'.tr,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchNotifications,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.md,
                  ),
                  itemCount: controller.notifications.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimens.xs),
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      notification: controller.notifications[index],
                    );
                  },
                ),
              );
          }
        }),
      ),
    );
  }
}
