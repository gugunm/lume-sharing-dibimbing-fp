// lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../services/auth_storage_service.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = AppConstants.lumeBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'apiKey': AppConstants.apiKey,
    };

    // Tambahkan interceptor untuk authorization
    _dio.interceptors.add(AuthInterceptor());
  }

  Dio get dio => _dio;
}

// Interceptor untuk menambahkan token secara otomatis
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Daftar endpoint yang membutuhkan authorization
    final privateEndpoints = AppConstants.privateEndpoints;

    // Cek apakah endpoint membutuhkan authorization
    final needsAuth = privateEndpoints.any(
      (endpoint) => options.path.startsWith(endpoint),
    );

    if (needsAuth) {
      final token = await AuthStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired atau invalid
    if (err.response?.statusCode == 401) {
      // Bisa tambahkan logic untuk auto-logout atau refresh token
      print('>>> Unauthorized: Token might be expired');
      // AuthStorageService.clearLoginData(); // Auto logout jika perlu
    }

    handler.next(err);
  }
}
