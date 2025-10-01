import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/post/domain/user_post.dart';

class UserPostRepository {
  final Dio _dio = ApiClient().dio;

  Future<UserPost> getUserPosts(
    String userId, {
    int size = 10,
    int page = 1,
  }) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '/api/v1/users-post/$userId',
        queryParameters: {'size': size, 'page': page},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> User Posts API Response: ${response.data}');
      return UserPost.fromJson(response.data);
    } on DioException catch (e) {
      print('>>> User Posts DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user posts',
      );
    } catch (e) {
      print('>>> User Posts Error: $e');
      throw Exception('Failed to fetch user posts: $e');
    }
  }
}
