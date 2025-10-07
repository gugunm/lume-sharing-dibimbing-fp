import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/dio_exception_handler.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/post_detail.dart';
import 'post_detail_model.dart';

class PostDetailRepository {
  final Dio _dio = ApiClient().dio;

  /// Fetch post detail by ID
  Future<PostDetailResponse> getPostDetail(String postId) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.get(
        '/api/v1/post/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Post Detail Response received from API');
        print('>>> Post ID: $postId');
        print('>>> ${response.data}');
      }

      final postDetailModelResponse = PostDetailModelResponse.fromJson(response.data);
      return postDetailModelResponse.toEntity();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('>>> DioException in getPostDetail: ${e.message}');
        print('>>> Error type: ${e.type}');
        print('>>> Response: ${e.response?.data}');
        print('>>> Status Code: ${e.response?.statusCode}');
      }

      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in getPostDetail: $e');
      }
      rethrow;
    }
  }

  /// Toggle like/unlike a post
  Future<void> toggleLike(String postId) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.post(
        '/api/v1/like',
        data: {'postId': postId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Toggle Like Response received from API');
        print('>>> Post ID: $postId');
        print('>>> ${response.data}');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('>>> DioException in toggleLike: ${e.message}');
        print('>>> Error type: ${e.type}');
        print('>>> Response: ${e.response?.data}');
        print('>>> Status Code: ${e.response?.statusCode}');
      }

      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in toggleLike: $e');
      }
      rethrow;
    }
  }

  /// Create a new comment for a post
  Future<CreateCommentResponse> createComment({
    required String postId,
    required String comment,
  }) async {
    final token = await AuthStorageService.getToken();

    try {
      final response = await _dio.post(
        '/api/v1/create-comment',
        data: {
          'postId': postId,
          'comment': comment,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (kDebugMode) {
        print('>>> Create Comment Response received from API');
        print('>>> Post ID: $postId');
        print('>>> ${response.data}');
      }

      final createCommentModelResponse = CreateCommentModelResponse.fromJson(response.data);
      return createCommentModelResponse.toEntity();
    } on DioException catch (e) {
      if (kDebugMode) {
        print('>>> DioException in createComment: ${e.message}');
        print('>>> Error type: ${e.type}');
        print('>>> Response: ${e.response?.data}');
        print('>>> Status Code: ${e.response?.statusCode}');
      }

      final appException = DioExceptionHandler.handleDioException(e);
      throw appException;
    } catch (e) {
      if (kDebugMode) {
        print('>>> Error in createComment: $e');
      }
      rethrow;
    }
  }
}