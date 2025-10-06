import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/update_profile.dart';
import '../../data/update_profile_repository.dart';

class UpdateProfileState {
  final bool isLoading;
  final String? error;

  UpdateProfileState({this.isLoading = false, this.error});

  UpdateProfileState copyWith({bool? isLoading, String? error}) {
    return UpdateProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UpdateProfileNotifier extends Notifier<UpdateProfileState> {
  @override
  UpdateProfileState build() {
    return UpdateProfileState();
  }

  UpdateProfileRepository get _repository =>
      ref.read(updateProfileRepositoryProvider);

  Future<bool> updateProfile({
    required String name,
    required String username,
    required String email,
    String? profilePictureUrl,
    String? phoneNumber,
    String? bio,
    String? website,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = UpdateProfileRequest(
        name: name,
        username: username,
        email: email,
        profilePictureUrl: profilePictureUrl,
        phoneNumber: phoneNumber,
        bio: bio,
        website: website,
      );

      final success = await _repository.updateProfile(request);

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final updateProfileRepositoryProvider = Provider<UpdateProfileRepository>((
  ref,
) {
  return UpdateProfileRepository();
});

final updateProfileProvider =
    NotifierProvider<UpdateProfileNotifier, UpdateProfileState>(() {
      return UpdateProfileNotifier();
    });
