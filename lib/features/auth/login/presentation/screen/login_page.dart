import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/constants/app_spacing.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/core/widgets/button_widget.dart';
import 'package:fp_sharing_photo/core/widgets/divider_widget.dart';
import 'package:fp_sharing_photo/core/widgets/form/text_field_widget.dart';
import 'package:fp_sharing_photo/core/widgets/snackbar_widget.dart';

import '../provider/login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmailAndPassword() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Email is required';
      });
      return;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text)) {
      setState(() {
        _emailError = 'Invalid email address';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      return;
    }
  }

  Future<void> _handleLogin() async {
    _validateEmailAndPassword();

    if (_emailError == null && _passwordError == null) {
      // Clear any previous errors from provider
      ref.read(authProvider.notifier).clearError();

      // Perform login
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state changes
    final authState = ref.watch(authProvider);

    // Listen to auth state changes for navigation and notifications
    ref.listen<LoginState>(authProvider, (previous, next) {
      // Handle successful login (only show message for fresh logins, not auto-login)
      if (next.isAuthenticated && !next.isLoading) {
        // Only show success message if previous state was not authenticated
        // This prevents showing the message during auto-login checks
        if (previous != null && !previous.isAuthenticated) {
          AppNotification.success(context, 'Login successfully!');
        }
        // Navigate to home page
        // Navigator.of(context).pushReplacementNamed(NavigationRoutes.home.path);
      }

      // Handle login error
      if (next.error != null && !next.isLoading) {
        AppNotification.error(context, next.error!);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lume Share',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Title
                Text(
                  'Sign in to your\nAccount',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Show error from provider if exists
                if (authState.error != null && !authState.isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: AppSpacing.l),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      border: Border.all(color: AppColors.error),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                    ),
                  ),

                // Email field
                Text('Email', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: AppSpacing.s),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _emailError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.l),

                // Password field
                Text(
                  'Password',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpacing.s),
                PasswordTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _passwordError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),

                // Continue button
                // CustomButton(
                //   text: 'Continue',
                //   onPressed: () {
                //     _validateEmailAndPassword();
                //     if (_emailError == null && _passwordError == null) {
                //       print('Login successful!');
                //     }
                //   },
                // ),
                // Continue button with loading state
                CustomButton(
                  text: authState.isLoading ? 'Signing in...' : 'Continue',
                  onPressed: authState.isLoading ? null : _handleLogin,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: AppSpacing.l),

                HorizontalDivider(),
                const SizedBox(height: AppSpacing.xl),

                // // Other options
                // CustomButton(
                //   text: 'Register Account',
                //   variant: ButtonVariant.outline,
                //   fontSize: 16,
                //   fontWeight: FontWeight.w500,
                //   onPressed: () {
                //     Navigator.pushNamed(
                //       context,
                //       NavigationRoutes.authRegister.path,
                //     );
                //   },
                // ),

                // Register button
                CustomButton(
                  text: 'Register Account',
                  variant: ButtonVariant.outline,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  enabled: !authState.isLoading, // Disable during loading
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NavigationRoutes.authRegister.path,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * EXAMPLE USAGE
 * 
// Di login page
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.login(email, password);

// Check authentication status
final isAuthenticated = ref.watch(isAuthenticatedProvider);

// Get current user
final currentUser = ref.watch(currentUserProvider);

// Logout
await authNotifier.logout();
 */
