// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'core/services/hive_service.dart';
import 'core/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive (termasuk register adapter)
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lume Share',
      debugShowCheckedModeBanner: false,
      initialRoute: NavigationRoutes.authLogin.path,
      onGenerateRoute: NavigationRoutes.onGenerateRoute,
      theme: lightTheme,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      //   useMaterial3: true,
      //   fontFamily: 'Figtree',
      // ),
    );
  }
}
