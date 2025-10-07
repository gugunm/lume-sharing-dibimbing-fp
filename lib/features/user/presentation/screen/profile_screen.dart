import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/user/presentation/provider/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? userId; // Optional userId parameter

  const ProfileScreen({super.key, this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _loggedUserId;

  @override
  void initState() {
    super.initState();

    // Load profile saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Get logged user ID to compare
      _loggedUserId = await AuthStorageService.getCurrentUser()?.id;
      setState(() {});

      // Load profile based on userId parameter
      ref.read(profileProvider.notifier).loadProfile(userId: widget.userId);
    });
  }

  bool get _isLoggedUser {
    return widget.userId == null || widget.userId == _loggedUserId;
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoggedUser ? 'Profile' : 'User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isLoggedUser) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                NavigationRoutes.home.path,
                (route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: profileState.isLoading && profileState.profile == null
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
          ? Center(child: Text('Error: ${profileState.error}'))
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User info row
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                profileState.profile?.user.profilePictureUrl ??
                                    '',
                              ),
                              backgroundColor: Colors.grey[200],
                            ),
                            const SizedBox(width: 16),
                            // Stats
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem(
                                    profileState.posts.length.toString(),
                                    'posts',
                                  ),
                                  _buildStatItem(
                                    profileState.profile?.user.totalFollowers
                                            .toString() ??
                                        '0',
                                    'followers',
                                  ),
                                  _buildStatItem(
                                    profileState.profile?.user.totalFollowing
                                            .toString() ??
                                        '0',
                                    'following',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Name and username
                        Text(
                          profileState.profile?.user.name ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${profileState.profile?.user.username ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Bio
                        if (profileState.profile?.user.bio != null &&
                            profileState.profile!.user.bio!.isNotEmpty)
                          Text(
                            profileState.profile!.user.bio!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 16),
                        // Action buttons - only show Edit Profile for logged user
                        if (_isLoggedUser)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      NavigationRoutes.updateUserProfile.path,
                                    );
                                  },
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                // Posts grid
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: Text(
                      'Posts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index >= profileState.posts.length) {
                      return Container();
                    }
                    final post = profileState.posts[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    );
                  }, childCount: profileState.posts.length),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
