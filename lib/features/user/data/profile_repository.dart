import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/profile.dart';
import '../../post/domain/user_post.dart'; // Import dari post domain sebelumnya

class ProfileRepository {
  final Dio _dio = ApiClient().dio;

  // Get logged user profile
  Future<GetLoggedUserProfileResponse> getLoggedUserProfile() async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '/api/v1/user',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> Get Logged User Profile API Response: ${response.data}');
      return GetLoggedUserProfileResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('>>> Get Logged User Profile DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user profile',
      );
    } catch (e) {
      print('>>> Get Logged User Profile Error: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Get user posts by ID
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

      print('>>> Get User Posts API Response: ${response.data}');
      return UserPost.fromJson(
        response.data,
      ); // Response pakai wrapper "data" seperti sebelumnya
    } on DioException catch (e) {
      print('>>> Get User Posts DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user posts',
      );
    } catch (e) {
      print('>>> Get User Posts Error: $e');
      throw Exception('Failed to fetch user posts: $e');
    }
  }

  // Get user profile by ID
  Future<GetLoggedUserProfileResponse> getUserProfileById(String userId) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '/api/v1/user/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> Get User Profile By ID API Response: ${response.data}');
      return GetLoggedUserProfileResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('>>> Get User Profile By ID DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user profile',
      );
    } catch (e) {
      print('>>> Get User Profile By ID Error: $e');
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  // Follow user
  Future<void> followUser(String userIdToFollow) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '/api/v1/follow',
        data: {'userIdFollow': userIdToFollow},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> Follow User API Response: ${response.data}');
    } on DioException catch (e) {
      print('>>> Follow User DioException: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to follow user');
    } catch (e) {
      print('>>> Follow User Error: $e');
      throw Exception('Failed to follow user: $e');
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String userId) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.delete(
        '/api/v1/unfollow/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> Unfollow User API Response: ${response.data}');
    } on DioException catch (e) {
      print('>>> Unfollow User DioException: ${e.message}');
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to unfollow user',
      );
    } catch (e) {
      print('>>> Unfollow User Error: $e');
      throw Exception('Failed to unfollow user: $e');
    }
  }
}
