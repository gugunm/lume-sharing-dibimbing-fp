// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/hive_helper.dart';
import 'features/user/presentation/screen/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive (termasuk register adapter)
  await HiveHelper.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lume Share',
      debugShowCheckedModeBanner: false,
      home: const UserPage(),
    );
  }
}
