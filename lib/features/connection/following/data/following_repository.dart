import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/dio_exception_handler.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/connection/following/data/following_model.dart';

import '../domain/following.dart';

class FollowingRepository {
  final Dio _dio = ApiClient().dio;

  Future<FollowingResponse> getFollowing({int page = 1, int size = 10}) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/my-following',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Following Response received from API');
        print('>>> Page: $page, Size: $size');
        print('>>> ${response.data}');
      }

      final followingModelResponse = FollowingModelResponse.fromJson(
        response.data,
      );
      return followingModelResponse.toEntity();
    } on DioException catch (e) {
      // Use the proper exception handler
      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in getFollowing: $e');
      }
      rethrow;
    }
  }

  Future<FollowingResponse> getInitialFollowing({int size = 10}) async {
    return getFollowing(page: 1, size: size);
  }

  Future<FollowingResponse> getNextFollowing({
    required int currentPage,
    int size = 10,
  }) async {
    return getFollowing(page: currentPage + 1, size: size);
  }

  bool hasMorePages(FollowingResponse response) {
    return response.data.currentPage < response.data.totalPages;
  }

  int getTotalFollowing(FollowingResponse response) {
    return response.data.totalItems;
  }
}
