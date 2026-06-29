import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../controllers/store_controller.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/product_card.dart';
import '../widgets/store_grid_shimmer.dart';

class StoreDetailsScreen extends GetView<StoreController> {
  const StoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          switch (controller.viewState.value) {
            case StoreViewState.loading:
              return const Column(
                children: [
                  StoreHeaderShimmer(),
                  Expanded(child: ProductGridShimmer()),
                ],
              );

            case StoreViewState.error:
              return EmptyStateView(
                icon: Icons.cloud_off_outlined,
                message:
                    (controller.errorMessage.value ?? 'unknown_error').tr,
                onRetry: controller.onRetryStoreDetails,
              );

            case StoreViewState.success:
              return _StoreContent(controller: controller);
          }
        }),
      ),
    );
  }
}

class _StoreContent extends StatelessWidget {
  final StoreController controller;

  const _StoreContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final store = controller.store.value;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          controller.fetchStoreDetails(),
          controller.fetchProducts(reset: true),
        ]);
      },
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            title: Text(store?.name ?? ''),
            expandedHeight: store?.coverImageUrl != null ? 140 : 0,
            flexibleSpace: store?.coverImageUrl != null
                ? AppNetworkImage(
                    imageUrl: store!.coverImageUrl,
                    width: double.infinity,
                    height: 140,
                    borderRadius: 0,
                  )
                : null,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.md),
              child: Row(
                children: [
                  AppNetworkImage(
                    imageUrl: store?.logoUrl,
                    width: 56,
                    height: 56,
                    borderRadius: 28,
                  ),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Text(
                      store?.name ?? '',
                      style: AppTypography.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (store != null && store.categories.isNotEmpty)
            SliverToBoxAdapter(
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.sm),
                  child: CategoryFilterChips(
                    categories: store.categories,
                    selectedCategoryId: controller.selectedCategoryId.value,
                    onSelected: controller.onCategorySelected,
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              child: Text('store_products'.tr, style: AppTypography.h3),
            ),
          ),
          _ProductsSliverGroup(controller: controller),
        ],
      ),
    );
  }
}

/// Bundles the product grid and its trailing "load more" indicator into
/// a single sliver group, so the loader sits below the grid as a
/// full-width row instead of being squeezed into a grid cell.
class _ProductsSliverGroup extends StatelessWidget {
  final StoreController controller;

  const _ProductsSliverGroup({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingProducts.value) {
        return const SliverToBoxAdapter(child: ProductGridShimmer());
      }

      if (controller.productsErrorMessage.value != null &&
          controller.products.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: EmptyStateView(
              icon: Icons.error_outline,
              message: controller.productsErrorMessage.value!.tr,
              onRetry: controller.onRetryProducts,
            ),
          ),
        );
      }

      if (controller.products.isEmpty) {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 240,
            child: EmptyStateView(
              icon: Icons.shopping_bag_outlined,
              message: 'store_empty_products'.tr,
            ),
          ),
        );
      }

      return SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppDimens.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppDimens.sm,
                crossAxisSpacing: AppDimens.sm,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    ProductCard(product: controller.products[index]),
                childCount: controller.products.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => Center(
                child: controller.isLoadingMore.value
                    ? const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimens.md,
                        ),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const SizedBox(height: AppDimens.md),
              ),
            ),
          ),
        ],
      );
    });
  }
}
