import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';

/// Talks to `GET home`. The endpoint itself is unauthenticated — it
/// isn't in `ApiEndpoints.publicEndpoints` (that list is reserved for
/// endpoints that must NEVER receive a token, like OTP), but the global
/// `AuthInterceptor` only attaches `Authorization` when a token actually
/// exists in `AuthService`. A guest with no session simply calls this
/// with no header; a logged-in user calls it with one, which the backend
/// is free to ignore. No special-casing needed here either way.
abstract class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getHomeSections();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<List<Map<String, dynamic>>> getHomeSections() async {
    try {
      final response = await _dio.get(ApiEndpoints.homeLayout);

      final apiResponse = ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List)
            .whereType<Map<String, dynamic>>()
            .toList(),
      );

      return apiResponse.data ?? <Map<String, dynamic>>[];
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }
}
