import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dio_error_handler.dart';

abstract class StoreRemoteDataSource {
  Future<Map<String, dynamic>> getStoreDetails(int storeId);

  Future<Map<String, dynamic>> getProducts({
    required int storeId,
    required int page,
    int? categoryId,
  });
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final Dio _dio;

  StoreRemoteDataSourceImpl(DioClient dioClient) : _dio = dioClient.dio;

  @override
  Future<Map<String, dynamic>> getStoreDetails(int storeId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.storeDetails(storeId.toString()),
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

  @override
  Future<Map<String, dynamic>> getProducts({
    required int storeId,
    required int page,
    int? categoryId,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {
          'store_id': storeId,
          'page': page,
          if (categoryId != null) 'store_product_category_id': categoryId,
        },
      );

      // The products envelope's `data` is itself a Laravel-style page
      // object ({data, current_page, last_page, ...}), not a plain
      // list — so it's passed straight through to ProductsPageModel
      // rather than being cast to a List here.
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
