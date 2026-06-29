import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_section_model.dart';

/// Concrete implementation bound to [HomeRepository].
///
/// Item-level sorting already happens inside `HomeSectionModel.fromJson`;
/// this layer is responsible for the section-level sort so the full
/// contract — "everything sorted by `sort_order` ascending" — is
/// satisfied before the list ever reaches the controller.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<HomeSectionModel>> getHomeSections() async {
    final rawSections = await _remoteDataSource.getHomeSections();

    final sections = rawSections.map(HomeSectionModel.fromJson).toList();
    sections.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return sections;
  }
}
