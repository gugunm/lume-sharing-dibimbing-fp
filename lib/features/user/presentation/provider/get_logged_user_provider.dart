import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/user.dart';
import '../../data/get_logged_user_repository.dart';

class GetLoggedUserState {
  final bool isLoading;
  final GetLoggedUserResponse? response;
  final String? error;

  GetLoggedUserState({this.isLoading = false, this.response, this.error});

  GetLoggedUserState copyWith({
    bool? isLoading,
    GetLoggedUserResponse? response,
    String? error,
  }) {
    return GetLoggedUserState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }

  User? get user => response?.user;
}

class GetLoggedUserNotifier extends Notifier<GetLoggedUserState> {
  @override
  GetLoggedUserState build() {
    return GetLoggedUserState();
  }

  GetLoggedUserRepository get _repository =>
      ref.read(getLoggedUserRepositoryProvider);

  Future<void> getLoggedUser() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getLoggedUser();
      state = state.copyWith(isLoading: false, response: response);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final getLoggedUserRepositoryProvider = Provider<GetLoggedUserRepository>((
  ref,
) {
  return GetLoggedUserRepository();
});

final getLoggedUserProvider =
    NotifierProvider<GetLoggedUserNotifier, GetLoggedUserState>(() {
      return GetLoggedUserNotifier();
    });
