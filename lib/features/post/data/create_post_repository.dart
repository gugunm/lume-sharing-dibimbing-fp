import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/create_post.dart';

class CreatePostRepository {
  final Dio _dio = ApiClient().dio;

  Future<bool> createPost(CreatePostRequest request) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '/api/v1/create-post',
        data: {"imageUrl": request.imageUrl, "caption": request.caption},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b', // dari Postman
          },
        ),
      );

      print('>>> Create Post API Response: ${response.data}');
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('>>> Create Post DioException: ${e.message}');
      if (e.response?.data != null) {
        print('>>> Response Data: ${e.response?.data}');
      }
      throw Exception(e.response?.data?['message'] ?? 'Create post failed');
    } catch (e) {
      print('>>> Create Post Error: $e');
      throw Exception('Create post failed: $e');
    }
  }
}
