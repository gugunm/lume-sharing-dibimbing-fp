import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/post_repository.dart';
import '../../domain/post.dart';

// Simple state class with Equatable
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

// Simple notifier
class PostNotifier extends Notifier<PostState> {
  PostRepository get _repository => ref.read(postRepositoryProvider);

  @override
  PostState build() {
    return const PostState();
  }

  // Load first page
  Future<void> loadInitialStories() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getInitialPosts();

      state = state.copyWith(
        posts: response.data.posts,
        isLoading: false,
        currentPage: response.data.currentPage,
        hasMore: _repository.hasMorePages(response),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Load more stories
  Future<void> loadMoreStories() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _repository.getNextPosts(
        currentPage: state.currentPage,
      );

      final updatedPosts = [...state.posts, ...response.data.posts];

      state = state.copyWith(
        posts: updatedPosts,
        isLoadingMore: false,
        currentPage: response.data.currentPage,
        hasMore: _repository.hasMorePages(response),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  // Refresh stories
  Future<void> refreshStories() async {
    state = const PostState();
    await loadInitialStories();
  }
}

// Providers
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postProvider = NotifierProvider<PostNotifier, PostState>(() {
  return PostNotifier();
});
