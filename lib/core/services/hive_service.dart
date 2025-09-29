// lib/core/utils/hive_helper.dart

import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/auth/login/data/login_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    // Inisialisasi Hive
    await Hive.initFlutter();

    // Register adapter untuk LoginResponseModel dan UserModel
    Hive.registerAdapter(LoginResponseModelAdapter());
    Hive.registerAdapter(UserModelAdapter());

    // Initialize auth storage service
    await AuthStorageService.init();
  }

  // Helper method untuk clear semua data
  static Future<void> clearAllData() async {
    await Hive.deleteFromDisk();
  }
}
