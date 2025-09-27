// lib/core/utils/hive_helper.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../../features/user/data/user_model.dart'; // Pastikan path benar

class HiveHelper {
  static Future<void> init() async {
    // Inisialisasi Hive
    await Hive.initFlutter();

    // Register adapter untuk UserModel
    Hive.registerAdapter(UserModelAdapter());
  }
}
