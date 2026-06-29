import 'package:get/get.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/routing/app_routes.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/models/home_section_item_model.dart';
import '../../data/models/home_section_model.dart';

/// Explicit view-state for the one-shot Home fetch, instead of juggling
/// separate booleans that could contradict each other (e.g. loading
/// AND error both true).
enum HomeViewState { loading, error, success }

class HomeController extends GetxController {
  final HomeRepository _homeRepository;

  HomeController(this._homeRepository);

  final Rx<HomeViewState> viewState = HomeViewState.loading.obs;
  final RxList<HomeSectionModel> sections = <HomeSectionModel>[].obs;
  final RxnString errorMessage = RxnString();

  @override
  void onReady() {
    super.onReady();
    fetchHomeSections();
  }

  Future<void> fetchHomeSections() async {
    viewState.value = HomeViewState.loading;
    errorMessage.value = null;

    try {
      final result = await _homeRepository.getHomeSections();
      sections.assignAll(result);
      viewState.value = HomeViewState.success;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      viewState.value = HomeViewState.error;
    } catch (_) {
      errorMessage.value = 'unknown_error';
      viewState.value = HomeViewState.error;
    }
  }

  Future<void> onRetry() => fetchHomeSections();

  /// Featured-store items keep their navigable id inside `link_data`,
  /// never on the item itself — this is the one place that reads it,
  /// so no widget has to know that detail.
  void onStoreItemTap(HomeSectionItemModel item) {
    final storeId = item.linkData?.id;
    if (storeId == null || storeId < 0) return;

    Get.toNamed(AppRoutes.storeDetails, arguments: storeId);
  }
}
