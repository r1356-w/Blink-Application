import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_section_renderer.dart';
import '../widgets/home_shimmer.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('home_title'.tr)),
      body: SafeArea(
        child: Obx(() {
          switch (controller.viewState.value) {
            case HomeViewState.loading:
              return const HomeShimmer();

            case HomeViewState.error:
              return EmptyStateView(
                icon: Icons.cloud_off_outlined,
                message: (controller.errorMessage.value ?? 'unknown_error').tr,
                onRetry: controller.onRetry,
              );

            case HomeViewState.success:
              if (controller.sections.isEmpty) {
                return EmptyStateView(
                  icon: Icons.storefront_outlined,
                  message: 'home_empty'.tr,
                );
              }
              return RefreshIndicator(
                onRefresh: controller.fetchHomeSections,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.md,
                  ),
                  itemCount: controller.sections.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimens.sm),
                  itemBuilder: (context, index) {
                    final section = controller.sections[index];
                    return HomeSectionRenderer(
                      section: section,
                      controller: controller,
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
