import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/create_post.dart';
import '../../data/create_post_repository.dart';

// State untuk create post
class CreatePostState {
  final bool isLoading;
  final String? error;

  CreatePostState({this.isLoading = false, this.error});

  CreatePostState copyWith({bool? isLoading, String? error}) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Gunakan Notifier, bukan StateNotifier
class CreatePostNotifier extends Notifier<CreatePostState> {
  @override
  CreatePostState build() {
    return CreatePostState();
  }

  CreatePostRepository get _repository =>
      ref.read(createPostRepositoryProvider);

  Future<bool> createPost(String imageUrl, String caption) async {
    // Update state dengan ref
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = CreatePostRequest(imageUrl: imageUrl, caption: caption);
      final success = await _repository.createPost(request);

      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// Provider untuk repository
final createPostRepositoryProvider = Provider<CreatePostRepository>((ref) {
  return CreatePostRepository();
});

// Gunakan NotifierProvider, bukan StateNotifierProvider
final createPostProvider =
    NotifierProvider<CreatePostNotifier, CreatePostState>(() {
      return CreatePostNotifier();
    });
