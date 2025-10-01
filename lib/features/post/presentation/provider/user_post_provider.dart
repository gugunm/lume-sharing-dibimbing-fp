import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/post/data/user_post_repository.dart';
import 'package:fp_sharing_photo/features/post/domain/user_post.dart';

// State untuk user post
class UserPostState {
  final bool isLoading;
  final List<Post> posts;
  final String? error;

  UserPostState({this.isLoading = false, this.posts = const [], this.error});

  UserPostState copyWith({bool? isLoading, List<Post>? posts, String? error}) {
    return UserPostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: error ?? this.error,
    );
  }
}

// Notifier untuk user post
class UserPostNotifier extends Notifier<UserPostState> {
  @override
  UserPostState build() {
    return UserPostState();
  }

  UserPostRepository get _repository => ref.read(userPostRepositoryProvider);

  Future<void> getUserPosts(
    String userId, {
    int size = 10,
    int page = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getUserPosts(
        userId,
        size: size,
        page: page,
      );
      state = state.copyWith(isLoading: false, posts: result.posts);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), posts: []);
    }
  }
}

// Provider untuk repository
final userPostRepositoryProvider = Provider<UserPostRepository>((ref) {
  return UserPostRepository();
});

// Provider untuk notifier
final userPostProvider = NotifierProvider<UserPostNotifier, UserPostState>(() {
  return UserPostNotifier();
});
