import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getNotifications();

  Future<void> registerDeviceToken({
    required String token,
    required int platform,
  });
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio _dio;

  NotificationsRemoteDataSourceImpl(DioClient dioClient)
      : _dio = dioClient.dio;

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.notifications);

      final apiResponse = ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List).whereType<Map<String, dynamic>>().toList(),
      );

      return apiResponse.data ?? <Map<String, dynamic>>[];
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }

  @override
  Future<void> registerDeviceToken({
    required String token,
    required int platform,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.deviceTokens,
        data: {
          'token': token,
          'platform': platform,
        },
      );
    } catch (error) {
      throw DioErrorHandler.handle(error);
    }
  }
}
