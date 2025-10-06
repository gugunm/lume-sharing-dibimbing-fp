import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/following_repository.dart';
import '../../domain/following.dart';

class FollowingState extends Equatable {
  final List<User> users;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const FollowingState({
    this.users = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  FollowingState copyWith({
    List<User>? users,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return FollowingState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    users,
    isLoading,
    isLoadingMore,
    hasMore,
    currentPage,
    error,
  ];
}

// Providers
final followingRepositoryProvider = Provider<FollowingRepository>((ref) {
  return FollowingRepository();
});

final followingProvider = AsyncNotifierProvider<FollowingNotifier, List<User>>(
  () {
    return FollowingNotifier();
  },
);

class FollowingNotifier extends AsyncNotifier<List<User>> {
  FollowingRepository get _repository => ref.read(followingRepositoryProvider);

  int _currentPage = 0;
  bool _hasMore = true;

  @override
  Future<List<User>> build() async {
    return await _loadInitialFollowing();
  }

  // Load first page
  Future<List<User>> _loadInitialFollowing() async {
    try {
      final response = await _repository.getInitialFollowing();
      _currentPage = response.data.currentPage;
      _hasMore = _repository.hasMorePages(response);
      return response.data.users;
    } catch (e) {
      throw e;
    }
  }

  // Load more following
  Future<void> loadMoreFollowing() async {
    // 1. Check if we can load more
    if (!_hasMore || state.isLoading) return;

    // 2. Get current users
    final currentUsers = state.value ?? [];

    try {
      // 3. Fetch next page from repository
      final response = await _repository.getNextFollowing(
        currentPage: _currentPage,
      );

      // 4. Combine old users with new users
      final updatedUsers = [...currentUsers, ...response.data.users];

      // 5. Update page tracking
      _currentPage = response.data.currentPage;
      _hasMore = _repository.hasMorePages(response);

      // 6. Update state with all users
      state = AsyncValue.data(updatedUsers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Refresh following
  Future<void> refreshFollowing() async {
    _currentPage = 0;
    _hasMore = true;
    state = const AsyncValue.loading();

    try {
      final users = await _loadInitialFollowing();
      state = AsyncValue.data(users);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}
