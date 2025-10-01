import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/post/data/user_post_repository.dart';
import 'package:fp_sharing_photo/features/post/domain/user_post.dart';

// Notifier untuk user post menggunakan AsyncNotifier
class UserPostNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    // Return empty list initially
    return [];
  }

  UserPostRepository get _repository => ref.read(userPostRepositoryProvider);

  Future<void> getUserPosts(
    String userId, {
    int size = 10,
    int page = 1,
  }) async {
    // Set loading state
    state = const AsyncLoading();

    try {
      final result = await _repository.getUserPosts(
        userId,
        size: size,
        page: page,
      );
      // Set success state with posts
      state = AsyncData(result.posts);
    } catch (e, stackTrace) {
      // Set error state
      state = AsyncError(e, stackTrace);
    }
  }

  // Method to add more posts (for pagination)
  Future<void> loadMorePosts(
    String userId, {
    int size = 10,
    int page = 1,
  }) async {
    // Don't show loading if we already have data
    final currentPosts = state.value ?? [];

    try {
      final result = await _repository.getUserPosts(
        userId,
        size: size,
        page: page,
      );
      // Append new posts to existing ones
      state = AsyncData([...currentPosts, ...result.posts]);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // Method to refresh posts
  Future<void> refreshPosts(String userId) async {
    return getUserPosts(userId);
  }
}

// Provider untuk repository
final userPostRepositoryProvider = Provider<UserPostRepository>((ref) {
  return UserPostRepository();
});

// Provider untuk notifier - now returns AsyncValue<List<Post>>
final userPostProvider = AsyncNotifierProvider<UserPostNotifier, List<Post>>(
  () {
    return UserPostNotifier();
  },
);
