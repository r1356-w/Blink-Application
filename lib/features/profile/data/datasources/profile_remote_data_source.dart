import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';

abstract class ProfileRemoteDataSource {
  /// Returns the unwrapped `data` block — the updated user object.
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  });

  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.updateProfile,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        },
      );

      // Per spec, `data` here IS the updated user object directly —
      // not nested one level further under a `user` key.
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as Map<String, dynamic>,
      );

      return apiResponse.data ?? <String, dynamic>{};
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }
}
