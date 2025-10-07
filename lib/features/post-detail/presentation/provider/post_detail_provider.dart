import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/post_detail_repository.dart';
import '../../domain/post_detail.dart';

// Repository provider
final postDetailRepositoryProvider = Provider<PostDetailRepository>((ref) {
  return PostDetailRepository();
});

// Post detail provider using FutureProvider
final postDetailProvider = FutureProvider.family<PostDetail, String>((ref, postId) async {
  final repository = ref.read(postDetailRepositoryProvider);
  final response = await repository.getPostDetail(postId);
  return response.data;
});

// Provider for creating comments
final createCommentProvider = FutureProvider.family<PostComment, Map<String, String>>((ref, params) async {
  final repository = ref.read(postDetailRepositoryProvider);
  final postId = params['postId']!;
  final comment = params['comment']!;
  
  final response = await repository.createComment(postId: postId, comment: comment);
  
  // Invalidate post detail to refresh the comments list
  ref.invalidate(postDetailProvider(postId));
  
  return response.data;
});

// Notifier provider for post detail actions
final postDetailNotifierProvider = Provider.family<PostDetailNotifier, String>((ref, postId) {
  return PostDetailNotifier(ref, postId);
});

class PostDetailNotifier {
  final Ref _ref;
  final String postId;
  
  PostDetailNotifier(this._ref, this.postId);
  
  PostDetailRepository get _repository => _ref.read(postDetailRepositoryProvider);

  // Refresh post detail
  Future<void> refreshPost() async {
    _ref.invalidate(postDetailProvider(postId));
  }

  // Toggle like for the post
  Future<void> toggleLike() async {
    try {
      await _repository.toggleLike(postId);
      // Refresh post detail to get updated like status
      _ref.invalidate(postDetailProvider(postId));
    } catch (e) {
      rethrow;
    }
  }

  // Create a new comment
  Future<void> createComment(String commentText) async {
    if (commentText.trim().isEmpty) return;
    
    try {
      await _repository.createComment(
        postId: postId,
        comment: commentText.trim(),
      );
      
      // Refresh post detail to include new comment
      _ref.invalidate(postDetailProvider(postId));
    } catch (e) {
      rethrow;
    }
  }
}