import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/profile.dart';
import '../../data/profile_repository.dart';
import '../../../post/domain/user_post.dart';

// State untuk profile
class ProfileState {
  final bool isLoading;
  final GetLoggedUserProfileResponse? profile;
  final List<Post> posts;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.posts = const [],
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    GetLoggedUserProfileResponse? profile,
    List<Post>? posts,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      error: error ?? this.error,
    );
  }
}

// Notifier untuk profile
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState();
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Ambil userId dari API Get Logged User
      final profileResponse = await _repository.getLoggedUserProfile();
      final userId = profileResponse.user.id;

      // Load posts dari user ID yang didapat dari API
      final posts = await _repository.getUserPosts(userId);

      state = state.copyWith(
        isLoading: false,
        profile: profileResponse,
        posts: posts.posts, // Ambil list posts dari UserPost
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        profile: null,
        posts: [],
      );
    }
  }
}

// Provider untuk repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// Provider untuk notifier
final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
