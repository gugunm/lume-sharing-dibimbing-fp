import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageRepository {
  final Dio _dio = ApiClient().dio;

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final token = await AuthStorageService.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Baca bytes dari XFile (kompatibel web dan mobile)
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Buat MultipartFile dari bytes
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromBytes(
          imageBytes,
          filename: imageFile.name, // gunakan nama file dari XFile
        ),
      });

      final response = await _dio.post(
        '/api/v1/upload-image',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'apiKey': 'c7b411cc-0e7c-4ad1-aa3f-822b00e7734b',
          },
        ),
      );

      print('>>> Upload Image API Response: ${response.data}');

      // Ambil URL dari response -> response.data['url']
      final imageUrl = response.data['url'] as String?;
      return imageUrl;
    } on DioException catch (e) {
      print('>>> Upload Image DioException: ${e.message}');
      if (e.response?.data != null) {
        print('>>> Response Data: ${e.response?.data}');
      }
      throw Exception(e.response?.data?['message'] ?? 'Upload image failed');
    } catch (e) {
      print('>>> Upload Image Error: $e');
      throw Exception('Upload image failed: $e');
    }
  }
}
