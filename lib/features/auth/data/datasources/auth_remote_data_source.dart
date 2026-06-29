import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';

/// Talks to `auth/request-otp` and `auth/verify-otp` over the shared
/// [DioClient]. Returns plain decoded maps (the unwrapped `data` field)
/// — turning those into typed models is the repository's job, not this
/// data source's.
abstract class AuthRemoteDataSource {
  Future<void> requestOtp({required String phoneNumber});

  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? notificationToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<void> requestOtp({required String phoneNumber}) async {
    try {
      await _dio.post(
        ApiEndpoints.requestOtp,
        data: {'phone_number': phoneNumber},
      );
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
    String? notificationToken,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
          'notification_token': notificationToken,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data as Map<String, dynamic>,
      );

      return apiResponse.data ?? <String, dynamic>{};
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }
}
