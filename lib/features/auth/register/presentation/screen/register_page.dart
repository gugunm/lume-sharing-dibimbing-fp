import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/constants/app_spacing.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/core/widgets/button_widget.dart';
import 'package:fp_sharing_photo/core/widgets/form/text_field_widget.dart';
import 'package:fp_sharing_photo/core/widgets/snackbar_widget.dart';

import '../../domain/register_validators.dart';
import '../provider/register_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // Controllers grouped in a map for easier management
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  // Form errors state
  Map<String, String?> _validationErrors = {};

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _validateForm() {
    final validationResult = RegisterFormValidators.validateRegistrationForm(
      name: _controllers['name']!.text,
      username: _controllers['username']!.text,
      email: _controllers['email']!.text,
      password: _controllers['password']!.text,
      confirmPassword: _controllers['confirmPassword']!.text,
    );

    setState(() {
      _validationErrors = validationResult;
    });
  }

  bool get _isFormValid =>
      _validationErrors.values.every((error) => error == null);

  void _handleSubmit() async {
    _validateForm();

    if (!_isFormValid) return;

    try {
      await ref
          .read(registerProvider.notifier)
          .register(
            _controllers['name']!.text,
            _controllers['username']!.text,
            _controllers['email']!.text,
            _controllers['password']!.text,
            _controllers['confirmPassword']!.text,
          );

      final registerState = ref.read(registerProvider);

      if (registerState.registerResponse != null &&
          registerState.error == null) {
        if (kDebugMode) print('Registration successful!');

        if (mounted) {
          AppNotification.success(context, 'Registration successfully!');

          _controllers.forEach((_, controller) => controller.clear());
          Navigator.pushReplacementNamed(
            context,
            NavigationRoutes.authLogin.path,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Registration failed: $e');

      if (mounted) {
        AppNotification.error(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        AppNotification.error(context, next.error!);
      }
    });

    final isLoading = ref.watch(isRegisterLoadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: AppSpacing.xxl),
                _buildTitle(context),
                const SizedBox(height: AppSpacing.xl),
                _buildForm(),
                const SizedBox(height: AppSpacing.xl),
                _buildSubmitButton(isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Lume Share', style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Create your\nAccount',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildFormField(
          key: 'name',
          label: 'Name',
          hintText: 'Masukkan nama Anda',
          keyboardType: TextInputType.text,
        ),
        _buildFormField(
          key: 'username',
          label: 'Username',
          hintText: 'Masukkan username Anda',
          keyboardType: TextInputType.text,
        ),
        _buildFormField(
          key: 'email',
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        _buildFormField(
          key: 'password',
          label: 'Password',
          hintText: 'Enter your password',
          isPassword: true,
        ),
        _buildFormField(
          key: 'confirmPassword',
          label: 'Confirm Password',
          hintText: 'Confirm your password',
          isPassword: true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String key,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.s),
        isPassword
            ? PasswordTextField(
                controller: _controllers[key]!,
                hintText: hintText,
              )
            : CustomTextField(
                controller: _controllers[key]!,
                hintText: hintText,
                keyboardType: keyboardType,
              ),
        if (_validationErrors[key] != null)
          _buildErrorMessage(_validationErrors[key]!),
        if (!isLast) const SizedBox(height: AppSpacing.l),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return CustomButton(
      text: isLoading ? 'Creating Account...' : 'Create Account',
      onPressed: isLoading ? null : _handleSubmit,
      isLoading: isLoading,
    );
  }
}
