import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/explore_repository.dart';
import '../../domain/explore.dart';

class ExploreState extends Equatable {
  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const ExploreState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  ExploreState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return ExploreState(
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
final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepository();
});

final exploreProvider = AsyncNotifierProvider<ExploreNotifier, List<Post>>(() {
  return ExploreNotifier();
});

class ExploreNotifier extends AsyncNotifier<List<Post>> {
  ExploreRepository get _repository => ref.read(exploreRepositoryProvider);

  int _currentPage = 0;
  bool _hasMore = true;

  @override
  Future<List<Post>> build() async {
    return await _loadInitialExplorePosts();
  }

  // Load first page
  Future<List<Post>> _loadInitialExplorePosts() async {
    try {
      final response = await _repository.getInitialExplorePosts();
      _currentPage = response.data.currentPage;
      _hasMore = _repository.hasMorePages(response);
      return response.data.posts;
    } catch (e) {
      throw e;
    }
  }

  // In explore_provider.dart
  Future<void> loadMoreExplorePosts() async {
    // 1. Check if we can load more
    if (!_hasMore || state.isLoading) return;

    // 2. Get current posts
    final currentPosts = state.value ?? [];

    try {
      // 3. Fetch next page from repository
      final response = await _repository.getNextExplorePosts(
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
  Future<void> refreshExplorePosts() async {
    _currentPage = 0;
    _hasMore = true;
    state = const AsyncValue.loading();

    try {
      final posts = await _loadInitialExplorePosts();
      state = AsyncValue.data(posts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}
