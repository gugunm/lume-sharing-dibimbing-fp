import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/connection/following/data/following_repository.dart';
import 'package:fp_sharing_photo/features/connection/following/presentation/provider/following_provider.dart';
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
  final bool isFollowing; // Track if logged user is following this profile

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.posts = const [],
    this.error,
    this.viewingUserId,
    this.isFollowing = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    GetLoggedUserProfileResponse? profile,
    List<Post>? posts,
    String? error,
    String? viewingUserId,
    bool? isFollowing,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      error: error ?? this.error,
      viewingUserId: viewingUserId ?? this.viewingUserId,
      isFollowing: isFollowing ?? this.isFollowing,
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
  FollowingRepository get _followingRepository =>
      ref.read(followingRepositoryProvider);

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

  // Check if user is in following list
  Future<bool> _checkIfFollowing(String userId) async {
    try {
      // Get all following users (you might need to fetch all pages)
      final followingResponse = await _followingRepository.getFollowing(
        size: 100,
      );

      // Check if userId exists in following list
      return followingResponse.data.users.any((user) => user.id == userId);
    } catch (e) {
      print('>>> Error checking following status: $e');
      return false; // Default to not following if check fails
    }
  }

  // Follow user
  Future<void> followUser(String userId) async {
    try {
      await _repository.followUser(userId);

      // Update state to reflect following
      state = state.copyWith(isFollowing: true);

      // Reload profile to update follower counts (preserve isFollowing state)
      await _reloadProfile(userId: userId, isFollowing: true);
    } catch (e) {
      // Check if error is "already following"
      final errorMessage = e.toString();
      if (errorMessage.contains('already follow')) {
        // User is already following, update state
        state = state.copyWith(isFollowing: true);
      } else {
        // Other error
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String userId) async {
    try {
      await _repository.unfollowUser(userId);

      // Update state to reflect unfollowing
      state = state.copyWith(isFollowing: false);

      // Reload profile to update follower counts (preserve isFollowing state)
      await _reloadProfile(userId: userId, isFollowing: false);
    } catch (e) {
      // Check if error is "not following"
      final errorMessage = e.toString();
      if (errorMessage.contains('not follow') ||
          errorMessage.contains('do not follow')) {
        // User is not following, update state
        state = state.copyWith(isFollowing: false);
      } else {
        // Other error
        state = state.copyWith(error: errorMessage);
      }
    }
  }

  // Helper method to reload profile while preserving isFollowing state
  Future<void> _reloadProfile({
    required String userId,
    required bool isFollowing,
  }) async {
    try {
      final profileResponse = await _repository.getUserProfileById(userId);
      final posts = await _repository.getUserPosts(userId);

      state = state.copyWith(
        profile: profileResponse,
        posts: posts.posts,
        isFollowing: isFollowing, // Preserve the follow state
      );
    } catch (e) {
      // If reload fails, keep current data but show error
      state = state.copyWith(error: e.toString());
    }
  }
}

final followingRepositoryProvider = Provider<FollowingRepository>((ref) {
  return FollowingRepository();
});

// Provider untuk repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// Provider untuk notifier
final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
