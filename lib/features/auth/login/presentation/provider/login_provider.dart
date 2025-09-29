import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/auth/login/data/login_repository.dart';
import 'package:fp_sharing_photo/features/auth/login/domain/login.dart';

// State untuk authentication
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final LoginResponse? loginResponse;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.loginResponse,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    LoginResponse? loginResponse,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loginResponse: loginResponse ?? this.loginResponse,
      error: error,
    );
  }
}

// Provider untuk LoginRepository
final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});

// Auth Notifier menggunakan Notifier (Riverpod 3.0+)
class AuthNotifier extends Notifier<AuthState> {
  late LoginRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(loginRepositoryProvider);

    // Defer the stored login check until after build is complete
    Future.microtask(() => _checkStoredLogin());

    return const AuthState();
  }

  // Check if user is already logged in from stored data
  void _checkStoredLogin() {
    final isLoggedIn = _repository.isLoggedIn();
    final storedResponse = _repository.getStoredLoginResponse();

    if (isLoggedIn && storedResponse != null && _repository.isTokenValid()) {
      state = state.copyWith(
        isAuthenticated: true,
        loginResponse: storedResponse,
      );
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _repository.login(request);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        loginResponse: response,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  // Logout method
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.logout();
      state = const AuthState(); // Reset to initial state
    } catch (e) {
      // Even if logout fails, clear local state
      state = const AuthState();
    }
  }

  // Get current user
  User? getCurrentUser() {
    return state.loginResponse?.user;
  }

  // Get current token
  Future<String?> getCurrentToken() async {
    return await _repository.getStoredToken();
  }

  // Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider untuk AuthNotifier menggunakan NotifierProvider (Riverpod 3.0+)
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Helper providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).loginResponse?.user;
});

final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});
