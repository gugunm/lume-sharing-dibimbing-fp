import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/story.dart';
import 'story_model.dart';

class StoryRepository {
  final Dio _dio = ApiClient().dio;

  /// Fetch following stories with pagination support for infinite scroll
  ///
  /// [page] - Page number (starts from 1)
  /// [size] - Number of items per page (default: 10)
  ///
  /// Returns [StoryResponse] containing stories and pagination info
  Future<StoryResponse> getFollowingStories({
    int page = 1,
    int size = 10,
  }) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/following-story',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Story Response received from API');
        print('>>> Page: $page, Size: $size');
        print('>>> ${response.data}');
      }

      final storyModelResponse = StoryModelResponse.fromJson(response.data);
      return storyModelResponse.toEntity();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('>>> DioException in getFollowingStories: ${e.message}');
        print('>>> Error type: ${e.type}');
        print('>>> Response: ${e.response?.data}');
      }
      print('>>> Error type: ${e.type}');
      print('>>> Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in getFollowingStories: $e');
      }
      rethrow;
    }
  }

  /// Fetch first page of following stories
  Future<StoryResponse> getInitialStories({int size = 10}) async {
    return getFollowingStories(page: 1, size: size);
  }

  /// Fetch next page of following stories
  Future<StoryResponse> getNextStories({
    required int currentPage,
    int size = 10,
  }) async {
    return getFollowingStories(page: currentPage + 1, size: size);
  }

  /// Check if there are more pages available
  bool hasMorePages(StoryResponse response) {
    return response.data.currentPage < response.data.totalPages;
  }

  /// Get total number of stories
  int getTotalStories(StoryResponse response) {
    return response.data.totalItems;
  }
}
