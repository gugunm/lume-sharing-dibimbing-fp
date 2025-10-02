import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/dio_exception_handler.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/post.dart';
import 'post_model.dart';

class PostRepository {
  final Dio _dio = ApiClient().dio;

  Future<PostResponse> getFollowingPosts({int page = 1, int size = 10}) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/following-post',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Post Response received from API');
        print('>>> Page: $page, Size: $size');
        print('>>> ${response.data}');
      }

      final postModelResponse = PostModelResponse.fromJson(response.data);
      return postModelResponse.toEntity();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('>>> DioException in getFollowingPosts: ${e.message}');
        print('>>> Error type: ${e.type}');
        print('>>> Response: ${e.response?.data}');
        print('>>> Status Code: ${e.response?.statusCode}');
      }

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

  /// Fetch first page of following stories
  Future<PostResponse> getInitialPosts({int size = 10}) async {
    return getFollowingPosts(page: 1, size: size);
  }

  /// Fetch next page of following stories
  Future<PostResponse> getNextPosts({
    required int currentPage,
    int size = 10,
  }) async {
    return getFollowingPosts(page: currentPage + 1, size: size);
  }

  /// Check if there are more pages available
  bool hasMorePages(PostResponse response) {
    return response.data.currentPage < response.data.totalPages;
  }

  /// Get total number of stories
  int getTotalPosts(PostResponse response) {
    return response.data.totalItems;
  }
}
