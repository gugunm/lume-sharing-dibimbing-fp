import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/post_repository.dart';
import '../../domain/post.dart';

class PostState extends Equatable {
  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const PostState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  PostState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPage,
    error,
  ];
}

// Providers
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postProvider = AsyncNotifierProvider<PostNotifier, List<Post>>(() {
  return PostNotifier();
});

class PostNotifier extends AsyncNotifier<List<Post>> {
  PostRepository get _repository => ref.read(postRepositoryProvider);

  int _currentPage = 0;
  bool _hasMore = true;

  @override
  Future<List<Post>> build() async {
    return await _loadInitialPosts();
  }

  // Load first page
  Future<List<Post>> _loadInitialPosts() async {
    try {
      final response = await _repository.getInitialPosts();
      _currentPage = response.data.currentPage;
      _hasMore = _repository.hasMorePages(response);
      return response.data.posts;
    } catch (e) {
      throw e;
    }
  }

  // Load more posts
  Future<void> loadMoreStories() async {
    // 1. Check if we can load more
    if (!_hasMore || state.isLoading) return;

    // 2. Get current posts
    final currentPosts = state.value ?? [];

    try {
      // 3. Fetch next page from repository
      final response = await _repository.getNextPosts(
        currentPage: _currentPage,
      );

      // 4. Combine old posts with new posts
      final updatedPosts = [...currentPosts, ...response.data.posts];

      // 5. Update page tracking
      _currentPage = response.data.currentPage;
      _hasMore = _repository.hasMorePages(response);

      // 6. Update state with all posts
      state = AsyncValue.data(updatedPosts);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Refresh posts
  Future<void> refreshStories() async {
    _currentPage = 0;
    _hasMore = true;
    state = const AsyncValue.loading();

    try {
      final posts = await _loadInitialPosts();
      state = AsyncValue.data(posts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;

  /// Toggle like/unlike for a post
  Future<void> toggleLike(String postId, bool currentIsLike) async {
    // Get current posts
    final currentPosts = state.value ?? [];

    // Find the post and update it optimistically
    final updatedPosts = currentPosts.map((post) {
      if (post.id == postId) {
        return Post(
          id: post.id,
          userId: post.userId,
          imageUrl: post.imageUrl,
          caption: post.caption,
          isLike: !currentIsLike,
          totalLikes: currentIsLike ? post.totalLikes - 1 : post.totalLikes + 1,
          user: post.user,
          createdAt: post.createdAt,
          updatedAt: post.updatedAt,
        );
      }
      return post;
    }).toList();

    // Update state optimistically
    state = AsyncValue.data(updatedPosts);

    try {
      // Call API
      if (currentIsLike) {
        await _repository.unlikePost(postId);
      } else {
        await _repository.likePost(postId);
      }
    } catch (e) {
      // Revert on error
      state = AsyncValue.data(currentPosts);
      rethrow;
    }
  }
}
