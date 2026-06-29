import '../../data/models/home_section_model.dart';

/// Contract `HomeController` depends on. The repository, not the
/// controller, owns the rule that sections must come back sorted by
/// `sort_order` — the controller just renders whatever list it receives.
abstract class HomeRepository {
  Future<List<HomeSectionModel>> getHomeSections();
}
