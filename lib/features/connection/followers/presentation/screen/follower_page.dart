import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';

import '../provider/follower_provider.dart';

class FollowerPage extends ConsumerStatefulWidget {
  const FollowerPage({super.key});

  @override
  ConsumerState<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends ConsumerState<FollowerPage> {
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
      // Step 3.4: Load more followers
      _loadMoreFollowers();
    }
  }

  Future<void> _loadMoreFollowers() async {
    // Step 4.1: Get the notifier (controller) for followers
    final notifier = ref.read(followerProvider.notifier);

    // Step 4.2: Check if there are more pages to load
    if (!notifier.hasMore) return;

    // Step 4.3: Set loading state to true
    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Step 4.4: Call the provider method to fetch next page
      await notifier.loadMoreFollowers();
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
    await ref.read(followerProvider.notifier).refreshFollowers();
  }

  @override
  Widget build(BuildContext context) {
    final followerAsync = ref.watch(followerProvider);

    return followerAsync.when(
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
      data: (users) => RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: _scrollController, // Attach the scroll controller
          itemCount:
              users.length +
              (_isLoadingMore ? 1 : 0), // Add 1 extra item for loader
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            // Show loading indicator at the end
            if (index == users.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GlobalLoadingWidget(),
                ),
              );
            }

            final user = users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profilePictureUrl),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error silently
                  },
                  child: user.profilePictureUrl.isEmpty
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Joined: ${_formatDate(user.createdAt)}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                onTap: () {
                  // TODO: Navigate to user profile
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => UserProfilePage(userId: user.id),
                  // ));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
