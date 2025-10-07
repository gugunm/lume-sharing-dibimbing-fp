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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b',
          },
        ),
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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b',
          },
        ),
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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b',
          },
        ),
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
}
