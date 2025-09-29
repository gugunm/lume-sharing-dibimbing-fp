import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import '../domain/login.dart';
import 'login_model.dart';

class LoginRepository {
  final Dio _dio = ApiClient().dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      // Convert domain entity ke model untuk request
      final requestModel = LoginRequestModel.fromEntity(request);

      // API call
      final response = await _dio.post(
        '/api/v1/login',
        data: requestModel.toJson(),
      );

      print('>>> Login API Response: ${response.data}');

      // Convert response JSON ke model
      final responseModel = LoginResponseModel.fromJson(response.data);

      // Simpan response login ke Hive untuk persistensi
      await AuthStorageService.saveLoginResponse(responseModel);
      await AuthStorageService.saveToken(responseModel.token);

      print('>>> Login response saved to local storage');

      // Return domain entity
      return responseModel.toEntity();
    } on DioException catch (e) {
      print('>>> DioException during login: ${e.message}');
      print('>>> Status Code: ${e.response?.statusCode}');
      print('>>> Response Data: ${e.response?.data}');

      // Handle different types of errors
      if (e.response?.statusCode == 401) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Invalid email or password';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Invalid request format';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 422) {
        final errorMessage = e.response?.data?['message'] ?? 'Validation error';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('Request timeout. Please try again');
      } else if (e.type == DioExceptionType.unknown) {
        throw Exception('Network error. Please check your internet connection');
      } else {
        final errorMessage =
            e.response?.data?['message'] ?? 'Login failed: ${e.message}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('>>> Unexpected error during login: $e');
      throw Exception('Unexpected error during login: $e');
    }
  }

  // Method untuk logout
  Future<void> logout() async {
    try {
      final token = await AuthStorageService.getToken();

      if (token != null) {
        // Call logout API
        await _dio.get(
          '/api/v1/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }

      // Clear local storage regardless of API call result
      await AuthStorageService.clearLoginData();
      print('>>> Logout completed and local data cleared');
    } on DioException catch (e) {
      print('>>> Logout API error: ${e.message}');
      // Still clear local data even if API call fails
      await AuthStorageService.clearLoginData();
    } catch (e) {
      print('>>> Unexpected logout error: $e');
      // Still clear local data
      await AuthStorageService.clearLoginData();
    }
  }

  // Method untuk cek status login dari local storage
  bool isLoggedIn() {
    return AuthStorageService.isLoggedIn();
  }

  // Method untuk mendapatkan token dari local storage
  Future<String?> getStoredToken() async {
    return await AuthStorageService.getToken();
  }

  // Method untuk mendapatkan user data dari local storage
  UserModel? getCurrentUser() {
    return AuthStorageService.getCurrentUser();
  }

  // Method untuk verifikasi token validity
  bool isTokenValid() {
    return AuthStorageService.isTokenValid();
  }

  // Method untuk auto-login menggunakan stored data
  LoginResponse? getStoredLoginResponse() {
    final storedResponse = AuthStorageService.getLoginResponse();
    return storedResponse?.toEntity();
  }
}
