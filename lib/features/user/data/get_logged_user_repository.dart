import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/user.dart';

class GetLoggedUserRepository {
  final Dio _dio = ApiClient().dio;

  Future<GetLoggedUserResponse> getLoggedUser() async {
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
      print(GetLoggedUserResponse.fromJson(response.data));
      return GetLoggedUserResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch user data',
      );
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }
}
