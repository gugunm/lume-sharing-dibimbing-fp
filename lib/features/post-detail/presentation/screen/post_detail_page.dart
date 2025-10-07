import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/constants/app_spacing.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import '../provider/post_detail_provider.dart';
import '../../domain/post_detail.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String formatCommentDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final postDetailAsync = ref.watch(postDetailProvider(widget.postId));
    final postDetailNotifier = ref.read(postDetailNotifierProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail')
      ),
      body: postDetailAsync.when(
        loading: () => const Center(child: GlobalLoadingWidget()),
        error: (error, stack) => _buildErrorWidget(error.toString(), postDetailNotifier),
        data: (postDetail) => _buildContent(postDetail, postDetailNotifier),
      ),
    );
  }

  Widget _buildErrorWidget(String error, PostDetailNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Error loading post detail',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: () => notifier.refreshPost(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PostDetail postDetail, PostDetailNotifier notifier) {
    return Column(
      children: [
        // Post content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Post card with same styling as home
                _buildPostCard(postDetail, notifier),
                
                const SizedBox(height: 8),
                
                // Comments section
                _buildCommentsSection(postDetail.comments),
              ],
            ),
          ),
        ),
        
        // Comment input
        _buildCommentInput(notifier),
      ],
    );
  }

  Widget _buildPostCard(PostDetail postDetail, PostDetailNotifier notifier) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info header - using ListTile like home
          ListTile(
            leading: CircleAvatar(
              backgroundImage: postDetail.user.profilePictureUrl.isNotEmpty
                  ? NetworkImage(postDetail.user.profilePictureUrl)
                  : null,
              onBackgroundImageError: (_, __) {},
              child: postDetail.user.profilePictureUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(postDetail.user.username),
            subtitle: Text(formatDate(postDetail.createdAt)),
          ),
          // Post image - direct like home, no borders
          if (postDetail.imageUrl.isNotEmpty)
            Image.network(
              postDetail.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          // Post actions and info - same padding as home
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Like button and count - simplified like home
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => notifier.toggleLike(),
                      child: Icon(
                        postDetail.isLike ? Icons.favorite : Icons.favorite_border,
                        color: postDetail.isLike ? Colors.red : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${postDetail.totalLikes} likes'),
                  ],
                ),
                const SizedBox(height: 8),
                // Caption
                if (postDetail.caption.isNotEmpty)
                  Text(
                    postDetail.caption, 
                    style: const TextStyle(fontSize: 14)
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(List<PostComment> comments) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'Comments (${comments.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          
          if (comments.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: const Column(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 48,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppSpacing.s),
                  Text(
                    'No comments yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Be the first to comment!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _buildCommentItem(comment);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(PostComment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.user.profilePictureUrl.isNotEmpty
                ? NetworkImage(comment.user.profilePictureUrl)
                : const AssetImage('assets/images/no-image.png') as ImageProvider,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      formatCommentDate(comment.createdAt),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  comment.comment,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(PostDetailNotifier notifier) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.s,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          IconButton(
            onPressed: _commentController.text.trim().isEmpty
                ? null
                : () => _submitComment(notifier),
            icon: const Icon(
              Icons.send,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment(PostDetailNotifier notifier) async {
    if (_commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();
    _commentController.clear();

    try {
      await notifier.createComment(commentText);
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Restore the comment text
      _commentController.text = commentText;
    }
  }
}