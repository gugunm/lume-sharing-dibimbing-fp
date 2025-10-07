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
  final String? viewingUserId; // Track which user we're viewing

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.posts = const [],
    this.error,
    this.viewingUserId,
  });

  ProfileState copyWith({
    bool? isLoading,
    GetLoggedUserProfileResponse? profile,
    List<Post>? posts,
    String? error,
    String? viewingUserId,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      error: error ?? this.error,
      viewingUserId: viewingUserId ?? this.viewingUserId,
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

  // Load profile - if userId is null, load logged user, otherwise load specific user
  Future<void> loadProfile({String? userId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final GetLoggedUserProfileResponse profileResponse;

      if (userId == null) {
        // Load logged user profile
        profileResponse = await _repository.getLoggedUserProfile();
      } else {
        // Load specific user profile by ID
        profileResponse = await _repository.getUserProfileById(userId);
      }

      final userIdToFetch = profileResponse.user.id;

      // Load posts from user ID
      final posts = await _repository.getUserPosts(userIdToFetch);

      state = state.copyWith(
        isLoading: false,
        profile: profileResponse,
        posts: posts.posts,
        viewingUserId: userIdToFetch,
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
