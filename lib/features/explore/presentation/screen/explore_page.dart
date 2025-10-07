import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import 'package:fp_sharing_photo/features/post-detail/presentation/utils/post_navigation_helper.dart';

import '../provider/explore_provider.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final ScrollController _scrollController = ScrollController();

  // ✅ STEP 1: Declare the _isLoadingMore variable
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Step 3.1: Prevent loading if already loading
    if (_isLoadingMore) return;

    // Step 3.2: Get scroll metrics
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9;

    // Step 3.3: Check if we've reached the threshold
    if (currentScroll >= threshold) {
      // Step 3.4: Load more posts
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    // Step 4.1: Get the notifier (controller) for explore posts
    final notifier = ref.read(exploreProvider.notifier);

    // Step 4.2: Check if there are more pages to load
    if (!notifier.hasMore) return;

    // Step 4.3: Set loading state to true
    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Step 4.4: Call the provider method to fetch next page
      await notifier.loadMoreExplorePosts();
    } finally {
      // Step 4.5: Reset loading state when done
      if (mounted) {
        // Check if widget is still in the tree
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // ✅ STEP 2: Add Pull-to-Refresh method
  Future<void> _onRefresh() async {
    await ref.read(exploreProvider.notifier).refreshExplorePosts();
  }

  @override
  Widget build(BuildContext context) {
    final explorePostAsync = ref.watch(exploreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationRoutes.home.path,
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: explorePostAsync.when(
          loading: () => const GlobalLoadingWidget(),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Gagal: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onRefresh,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
          data: (posts) => RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              controller: _scrollController, // Attach the scroll controller
              itemCount:
                  posts.length +
                  (_isLoadingMore ? 1 : 0), // Add 1 extra item for loader
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // crossAxisSpacing: 4,
                // mainAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              // itemCount: posts.length,
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
                return GestureDetector(
                  onTap: () {
                    PostNavigationHelper.navigateToPostDetail(context, post.id);
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: AppColors.divider, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: post.imageUrl.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    'assets/images/no-image.png',
                                    fit: BoxFit.contain,
                                    width: 60,
                                    height: 60,
                                    opacity: const AlwaysStoppedAnimation(0.5),
                                  ),
                                )
                              : Image.network(
                                  post.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Image.asset(
                                          'assets/images/no-image.png',
                                          fit: BoxFit.contain,
                                          width: 60,
                                          height: 60,
                                          opacity: const AlwaysStoppedAnimation(
                                            0.5,
                                          ),
                                        ),
                                      ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     post.imageUrl.isEmpty ? 'No image URL' : post.imageUrl,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: post.caption.isEmpty
                              ? const Text('No caption')
                              : Text(
                                  post.caption,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
