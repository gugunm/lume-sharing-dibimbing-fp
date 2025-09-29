// lib/features/user/data/user_repository.dart

import 'package:dio/dio.dart';
import 'package:fp_sharing_photo/core/networks/api_client.dart';
import 'package:hive/hive.dart';
import '../domain/user.dart';
import 'user_model.dart';

class UserRepository {
  final Dio _dio = ApiClient().dio;
  static const String _boxName = 'users';

  Future<List<User>> getUsers() async {
    try {
      // 1. Ambil dari API
      final response = await _dio.get('/users');
      print('>>> Response diterima dari API');
      print('>>> ${response.data}');

      // Ekstrak data dari response sesuai struktur API
      List<dynamic> jsonList;
      if (response.data is Map && response.data.containsKey('users')) {
        // Format dummyjson.com
        jsonList = response.data['users'];
      } else {
        // Format lain (fallback)
        jsonList = response.data;
      }

      final models = jsonList
          .where((e) => e != null) // Filter out null entries
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // 2. Simpan ke Hive
      print('>>> Menyimpan ke Hive');
      final box = await Hive.openBox<UserModel>(_boxName);
      await box.clear();
      await box.addAll(models);

      // 3. Kembalikan sebagai Entity (domain)
      print('>>> Mengembalikan data');
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      print('>>> DioException: ${e.message}');
      print('>>> Error type: ${e.type}');
      print('>>> Response: ${e.response?.data}');
      // 4. Fallback ke cache lokal
      try {
        print('>>> Mencoba mengambil dari cache');
        final box = await Hive.openBox<UserModel>(_boxName);
        final models = box.values.toList();
        print('>>> Data dari cache: ${models.length} items');
        return models.map((model) => model.toEntity()).toList();
      } catch (cacheError) {
        print('>>> Cache error: $cacheError');
        rethrow; // Tidak ada cache → error
      }
    } catch (e) {
      print('>>> Error lain: $e');
      rethrow;
    }
  }
}
