import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../data/story_repository.dart';
import '../../domain/story.dart';

// Simple state class with Equatable
class StoryState extends Equatable {
  final List<Story> stories;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const StoryState({
    this.stories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  StoryState copyWith({
    List<Story>? stories,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return StoryState(
      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    stories,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPage,
    error,
  ];
}

// Simple notifier
class StoryNotifier extends Notifier<StoryState> {
  StoryRepository get _repository => ref.read(storyRepositoryProvider);

  @override
  StoryState build() {
    return const StoryState();
  }

  // Load first page
  Future<void> loadInitialStories() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getInitialStories();

      state = state.copyWith(
        stories: response.data.stories,
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
      final response = await _repository.getNextStories(
        currentPage: state.currentPage,
      );

      final updatedStories = [...state.stories, ...response.data.stories];

      state = state.copyWith(
        stories: updatedStories,
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
    state = const StoryState();
    await loadInitialStories();
  }
}

// Providers
final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepository();
});

final storyProvider = NotifierProvider<StoryNotifier, StoryState>(() {
  return StoryNotifier();
});
