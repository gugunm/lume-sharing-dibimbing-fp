import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/register_repository.dart';
import '../../domain/register.dart';

class RegisterState {
  final bool isLoading;
  final RegisterResponse? registerResponse;
  final String? error;

  const RegisterState({
    this.isLoading = false,
    this.registerResponse,
    this.error,
  });

  RegisterState copyWith({
    bool? isLoading,
    RegisterResponse? registerResponse,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      registerResponse: registerResponse ?? this.registerResponse,
      error: error,
    );
  }
}

final registerRepositoryProvider = Provider<RegisterRepository>((ref) {
  return RegisterRepository();
});

class RegisterNotifier extends Notifier<RegisterState> {
  late RegisterRepository _repository;

  @override
  RegisterState build() {
    _repository = ref.read(registerRepositoryProvider);
    return const RegisterState();
  }

  Future<void> register(
    String name,
    String username,
    String email,
    String password,
    String passwordRepeat,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterRequest(
        name: name,
        username: username,
        email: email,
        password: password,
        passwordRepeat: passwordRepeat,
      );
      final response = await _repository.register(request);

      state = state.copyWith(
        isLoading: false,
        registerResponse: response,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(() {
  return RegisterNotifier();
});

final isRegisterLoadingProvider = Provider<bool>((ref) {
  return ref.watch(registerProvider).isLoading;
});

final registerErrorProvider = Provider<String?>((ref) {
  return ref.watch(registerProvider).error;
});
