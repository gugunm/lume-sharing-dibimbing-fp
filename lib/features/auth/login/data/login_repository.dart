import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/core/errors/errors.dart';
import '../domain/login.dart';
import 'login_model.dart';

class LoginRepository {
  final Dio _dio = ApiClient().dio;

  Future<LoginResponse> login(LoginRequest request) async {
    return await ExceptionHandler.handleAsync(() async {
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
    });
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
    } catch (e) {
      print('>>> Logout error: ${e.toString()}');
      // Still clear local data even if API call fails
      await AuthStorageService.clearLoginData();

      // Only rethrow if it's a critical error that should be handled by UI
      if (e is! DioException) {
        rethrow;
      }
    }
  }

  // Method untuk cek status login dari local storage
  bool isLoggedIn() {
    return ExceptionHandler.handleSync(() {
      return AuthStorageService.isLoggedIn();
    });
  }

  // Method untuk mendapatkan token dari local storage
  Future<String?> getStoredToken() async {
    return await ExceptionHandler.handleAsync(() async {
      return await AuthStorageService.getToken();
    });
  }

  // Method untuk mendapatkan user data dari local storage
  UserModel? getCurrentUser() {
    return ExceptionHandler.handleSync(() {
      return AuthStorageService.getCurrentUser();
    });
  }

  // Method untuk verifikasi token validity
  bool isTokenValid() {
    return ExceptionHandler.handleSync(() {
      return AuthStorageService.isTokenValid();
    });
  }

  // Method untuk auto-login menggunakan stored data
  LoginResponse? getStoredLoginResponse() {
    return ExceptionHandler.handleSync(() {
      final storedResponse = AuthStorageService.getLoginResponse();
      return storedResponse?.toEntity();
    });
  }
}
