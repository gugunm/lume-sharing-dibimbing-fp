import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/dio_exception_handler.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/explore/data/explore_model.dart';

import '../domain/explore.dart';

class ExploreRepository {
  final Dio _dio = ApiClient().dio;

  Future<ExploreResponse> getExplorePosts({int page = 1, int size = 15}) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/explore-post',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Post Response received from API');
        print('>>> Page: $page, Size: $size');
        print('>>> ${response.data}');
      }

      final exploreModelResponse = ExploreModelResponse.fromJson(response.data);
      return exploreModelResponse.toEntity();
    } on DioException catch (e) {
      // Use the proper exception handler
      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in getFollowingPosts: $e');
      }
      rethrow;
    }
  }

  Future<ExploreResponse> getInitialExplorePosts({int size = 15}) async {
    return getExplorePosts(page: 1, size: size);
  }

  Future<ExploreResponse> getNextExplorePosts({
    required int currentPage,
    int size = 10,
  }) async {
    return getExplorePosts(page: currentPage + 1, size: size);
  }

  bool hasMorePages(ExploreResponse response) {
    return response.data.currentPage < response.data.totalPages;
  }

  int getTotalExplorePosts(ExploreResponse response) {
    return response.data.totalItems;
  }
}
