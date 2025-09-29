import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final bool requireAuth;

  const AuthGuard({super.key, required this.child, this.requireAuth = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Show loading while checking authentication
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If authentication is required but user is not authenticated
    if (requireAuth && !authState.isAuthenticated) {
      // Navigate to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushReplacementNamed(NavigationRoutes.authLogin.path);
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If user is authenticated but trying to access auth pages
    if (!requireAuth && authState.isAuthenticated) {
      // Navigate to home or main page (you need to add home route)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}

// Helper widget untuk protected routes
class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(requireAuth: true, child: child);
  }
}

// Helper widget untuk guest routes (hanya untuk yang belum login)
class GuestRoute extends StatelessWidget {
  final Widget child;

  const GuestRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(requireAuth: false, child: child);
  }
}


/**
 * EXAMPLE USAGE
// Di dalam widget/page
class SomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      requireAuth: true, // true = butuh login, false = guest only
      child: Scaffold(
        appBar: AppBar(title: Text('Protected Page')),
        body: Center(
          child: Text('This page requires authentication'),
        ),
      ),
    );
  }
}

 */