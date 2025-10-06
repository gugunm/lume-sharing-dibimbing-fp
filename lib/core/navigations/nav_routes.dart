import 'package:flutter/material.dart';
import 'package:fp_sharing_photo/core/navigations/guards/auth_guard.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/screen/login_page.dart';
import 'package:fp_sharing_photo/features/auth/register/presentation/screen/register_page.dart';
import 'package:fp_sharing_photo/features/home/presentation/screen/home_page.dart';
import 'package:fp_sharing_photo/features/post/presentation/screen/create_post_page.dart';
import 'package:fp_sharing_photo/features/post/presentation/screen/user_post.dart';
import 'package:fp_sharing_photo/features/user/presentation/screen/update_profile_screen.dart';

enum NavigationRoutes {
  authLogin(path: '/auth/login'),
  authRegister(path: '/auth/register'),
  home(path: '/home'), // Tambahkan route home
  profile(path: '/profile'),

  createPost(path: '/create-post'),
  userPost(path: '/users-post/:userId'),
  updateUserProfile(path: '/update-profile');

  const NavigationRoutes({required this.path});

  final String path;

  // static final Map<String, Widget Function(BuildContext)> _routes = {
  //   NavigationRoutes.authLogin.path: (context) => const LoginPage(),
  //   NavigationRoutes.authRegister.path: (context) => const RegisterPage(),
  // };

  // Helper method to generate path with parameters
  String pathWithParams(Map<String, String> params) {
    String result = path;
    params.forEach((key, value) {
      result = result.replaceAll(':$key', value);
    });
    return result;
  }

  static final Map<String, Widget Function(BuildContext)> _routes = {
    // Guest routes (hanya untuk yang belum login)
    NavigationRoutes.authLogin.path: (context) =>
        const GuestRoute(child: LoginPage()),
    NavigationRoutes.authRegister.path: (context) =>
        const GuestRoute(child: RegisterPage()),

    // Protected routes (hanya untuk yang sudah login)
    NavigationRoutes.home.path: (context) => const ProtectedRoute(
      child: HomePage(), // Anda perlu buat HomePage
    ),
    NavigationRoutes.createPost.path: (context) =>
        const ProtectedRoute(child: CreatePostScreen()),
    NavigationRoutes.updateUserProfile.path: (context) =>
        const ProtectedRoute(child: UpdateProfileScreen()),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');

    // Handle userPost route with parameter
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'users-post') {
      final userId = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (context) =>
            ProtectedRoute(child: UserPostScreen(userId: userId)),
        settings: settings,
      );
    }

    // Handle static routes
    final builder = _routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
