import 'package:flutter/material.dart';
import 'package:fp_sharing_photo/core/navigations/guards/auth_guard.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/screen/login_page.dart';
import 'package:fp_sharing_photo/features/auth/register/presentation/screen/register_page.dart';
import 'package:fp_sharing_photo/features/post/presentation/screen/post_page.dart';

enum NavigationRoutes {
  authLogin(path: '/auth/login'),
  authRegister(path: '/auth/register'),
  home(path: '/home'), // Tambahkan route home
  profile(path: '/profile');

  const NavigationRoutes({required this.path});

  final String path;

  // static final Map<String, Widget Function(BuildContext)> _routes = {
  //   NavigationRoutes.authLogin.path: (context) => const LoginPage(),
  //   NavigationRoutes.authRegister.path: (context) => const RegisterPage(),
  // };

  static final Map<String, Widget Function(BuildContext)> _routes = {
    // Guest routes (hanya untuk yang belum login)
    NavigationRoutes.authLogin.path: (context) =>
        const GuestRoute(child: LoginPage()),
    NavigationRoutes.authRegister.path: (context) =>
        const GuestRoute(child: RegisterPage()),

    // Protected routes (hanya untuk yang sudah login)
    NavigationRoutes.home.path: (context) => const ProtectedRoute(
      child: PostPage(), // Anda perlu buat HomePage
    ),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
