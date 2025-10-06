import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import '../provider/post_provider.dart';

class HomePostSection extends ConsumerStatefulWidget {
  const HomePostSection({super.key});

  @override
  ConsumerState<HomePostSection> createState() => _HomePostSectionState();
}

class _HomePostSectionState extends ConsumerState<HomePostSection> {
  // ✅ STEP 1: Add ScrollController
  final ScrollController _scrollController = ScrollController();

  // ✅ STEP 2: Declare the _isLoadingMore variable
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // ✅ STEP 3: Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // ✅ STEP 4: Clean up scroll controller
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ STEP 5: Add scroll detection method
  void _onScroll() {
    // Prevent loading if already loading
    if (_isLoadingMore) return;

    // Get scroll metrics
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9;

    // Check if we've reached the threshold
    if (currentScroll >= threshold) {
      _loadMorePosts();
    }
  }

  // ✅ STEP 6: Add method to load more posts
  Future<void> _loadMorePosts() async {
    final notifier = ref.read(postProvider.notifier);

    // Check if there are more pages to load
    if (!notifier.hasMore) return;

    // Set loading state to true
    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Call the provider method to fetch next page
      await notifier.loadMoreStories();
    } finally {
      // Reset loading state when done
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // ✅ STEP 7: Add Pull-to-Refresh method
  Future<void> _onRefresh() async {
    await ref.read(postProvider.notifier).refreshStories();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postProvider);

    return Expanded(
      child: postAsync.when(
        loading: () => const Center(child: GlobalLoadingWidget()),
        error: (error, stack) => _buildErrorWidget(error.toString()),
        data: (posts) => _buildPostsList(posts),
      ),
    );
  }

  // ✅ STEP 8: Update posts list with RefreshIndicator and loading indicator
  Widget _buildPostsList(List posts) {
    // Empty state
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No posts available'),
                    SizedBox(height: 8),
                    Text(
                      'Follow some users to see their posts here',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Posts list with scroll controller and loading indicator
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController, // Attach scroll controller
        itemCount: posts.length + (_isLoadingMore ? 1 : 0), // Add 1 for loader
        itemBuilder: (context, index) {
          // Show loading indicator at the end
          if (index == posts.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: GlobalLoadingWidget(),
              ),
            );
          }

          final post = posts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    // Check if it's a 403 error (access forbidden)
    final is403Error =
        error.contains('403') ||
        error.toLowerCase().contains('forbidden') ||
        error.toLowerCase().contains('access denied');

    final isNetworkError =
        error.toLowerCase().contains('network') ||
        error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('timeout');

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              is403Error
                  ? Icons.lock_outline
                  : isNetworkError
                  ? Icons.wifi_off
                  : Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              _getErrorTitle(error, is403Error, isNetworkError),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              _getErrorMessage(error, is403Error, isNetworkError),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!is403Error) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(postProvider.notifier).refreshStories();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  ),
                  SizedBox(width: 12),
                ],
                OutlinedButton(
                  onPressed: () {
                    // Navigate to explore or login page based on error type
                    if (is403Error) {
                      _handleAuthError();
                    } else {
                      _showErrorDetails(error);
                    }
                  },
                  child: Text(is403Error ? 'Login Again' : 'Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorTitle(String error, bool is403Error, bool isNetworkError) {
    if (is403Error) {
      return 'Access Denied';
    } else if (isNetworkError) {
      return 'Connection Problem';
    } else {
      return 'Something went wrong';
    }
  }

  String _getErrorMessage(String error, bool is403Error, bool isNetworkError) {
    if (is403Error) {
      return 'Your session may have expired or you don\'t have permission to view posts. Please login again.';
    } else if (isNetworkError) {
      return 'Please check your internet connection and try again.';
    } else {
      return 'We encountered an issue while loading posts. Please try again.';
    }
  }

  void _handleAuthError() {
    // Navigate to login page or show login dialog
    // You can implement this based on your navigation structure
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Session Expired'),
        content: Text(
          'Your session has expired. Please login again to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login page
              // Navigator.pushNamed(context, '/login');
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showErrorDetails(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error Details'),
        content: SingleChildScrollView(child: Text(error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(post) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.user.profilePictureUrl),
              onBackgroundImageError: (_, __) {},
              child: post.user.profilePictureUrl.isEmpty
                  ? Icon(Icons.person)
                  : null,
            ),
            title: Text(post.user.username),
            subtitle: Text(_formatDate(post.createdAt)),
          ),
          // Post image
          Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 300,
                color: Colors.grey[200],
                child: Center(
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
          // Post actions and info
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      post.isLike ? Icons.favorite : Icons.favorite_border,
                      color: post.isLike ? Colors.red : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text('${post.totalLikes} likes'),
                  ],
                ),
                SizedBox(height: 8),
                if (post.caption.isNotEmpty)
                  Text(post.caption, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
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
}
