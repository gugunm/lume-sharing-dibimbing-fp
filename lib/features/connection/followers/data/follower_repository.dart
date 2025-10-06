import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/dio_exception_handler.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/connection/followers/data/follower_model.dart';

import '../domain/follower.dart';

class FollowerRepository {
  final Dio _dio = ApiClient().dio;

  Future<FollowerResponse> getFollowers({int page = 1, int size = 10}) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/my-followers',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Follower Response received from API');
        print('>>> Page: $page, Size: $size');
        print('>>> ${response.data}');
      }

      final followerModelResponse = FollowerModelResponse.fromJson(
        response.data,
      );
      return followerModelResponse.toEntity();
    } on DioException catch (e) {
      // Use the proper exception handler
      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in getFollowers: $e');
      }
      rethrow;
    }
  }

  Future<FollowerResponse> getInitialFollowers({int size = 10}) async {
    return getFollowers(page: 1, size: size);
  }

  Future<FollowerResponse> getNextFollowers({
    required int currentPage,
    int size = 10,
  }) async {
    return getFollowers(page: currentPage + 1, size: size);
  }

  bool hasMorePages(FollowerResponse response) {
    return response.data.currentPage < response.data.totalPages;
  }

  int getTotalFollowers(FollowerResponse response) {
    return response.data.totalItems;
  }
}
