import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/update_profile.dart';

class UpdateProfileRepository {
  final Dio _dio = ApiClient().dio;

  Future<bool> updateProfile(UpdateProfileRequest request) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.post(
        '/api/v1/update-profile',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Update profile failed');
    } catch (e) {
      throw Exception('Update profile failed: $e');
    }
  }
}
