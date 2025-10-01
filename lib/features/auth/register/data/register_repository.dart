import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fp_sharing_photo/core/errors/errors.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';

import '../domain/register.dart';
import 'register_model.dart';

class RegisterRepository {
  final Dio _dio = ApiClient().dio;

  Future<RegisterResponse> register(RegisterRequest request) async {
    return await ExceptionHandler.handleAsync(() async {
      // Convert domain entity ke model untuk request
      final requestModel = RegisterRequestModel.fromEntity(request);

      // API call
      final response = await _dio.post(
        '/api/v1/register',
        data: requestModel.toJson(),
      );

      if (kDebugMode) print('>>> Register API Response: ${response.data}');

      // Convert response JSON ke model
      final responseModel = RegisterResponseModel.fromJson(response.data);

      // Return domain entity
      return responseModel.toEntity();
    });
  }
}
