// Deliberate cross-feature data-layer import: both Auth and Profile
// receive the exact same "user" JSON shape from the backend, so this
// reuses `UserModel.fromJson` rather than duplicating that parsing
// logic. Domain/presentation layers stay decoupled from this choice —
// only this repository implementation knows it.
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final json = await _remoteDataSource.updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    return UserModel.fromJson(json);
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }
}
