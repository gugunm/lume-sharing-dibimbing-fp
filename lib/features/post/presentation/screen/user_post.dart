import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import 'package:fp_sharing_photo/features/post/presentation/provider/user_post_provider.dart';
// import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';

class UserPostScreen extends ConsumerStatefulWidget {
  final String userId;
  const UserPostScreen({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends ConsumerState<UserPostScreen> {
  @override
  void initState() {
    super.initState();

    // Ambil user ID dari auth state
    // final authState = ref.read(authProvider);
    // final userId = authState.loginResponse?.user.id;
    // final userId = widget.userId;

    // Load user posts saat screen dibuka
    // ref.read(userPostProvider.notifier).getUserPosts(userId);

    // Delay the provider modification until after the widget tree is built
    Future.microtask(() {
      final userId = widget.userId;
      ref.read(userPostProvider.notifier).getUserPosts(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPostAsync = ref.watch(userPostProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Posts')),
      body: userPostAsync.when(
        loading: () => const GlobalLoadingWidget(),
        error: (error, stack) => Center(child: Text('Gagal: $error')),
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(
                post.caption,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(post.imageUrl),
            );
          },
        ),
      ),
      // body: userPostState.isLoading && userPostState.posts.isEmpty
      //     ? const Center(child: CircularProgressIndicator())
      //     : userPostState.error != null
      //     ? Center(child: Text('Error: ${userPostState.error}'))
      //     : userPostState.posts.isEmpty
      //     ? const Center(child: Text('No posts yet'))
      //     : ListView.builder(
      //         itemCount: userPostState.posts.length,
      //         itemBuilder: (context, index) {
      //           final post = userPostState.posts[index];
      //           return Card(
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   // User info
      //                   Row(
      //                     children: [
      //                       CircleAvatar(
      //                         backgroundImage: NetworkImage(
      //                           post.user.profilePictureUrl,
      //                         ),
      //                       ),
      //                       const SizedBox(width: 8),
      //                       Text(post.user.username),
      //                     ],
      //                   ),
      //                   const SizedBox(height: 8),
      //                   // Image post
      //                   Image.network(
      //                     post.imageUrl,
      //                     height: 300,
      //                     width: double.infinity,
      //                     fit: BoxFit.cover,
      //                   ),
      //                   const SizedBox(height: 8),
      //                   // Caption
      //                   Text(post.caption),
      //                   const SizedBox(height: 8),
      //                   // Like info
      //                   Row(
      //                     children: [
      //                       Icon(
      //                         post.isLike
      //                             ? Icons.favorite
      //                             : Icons.favorite_border,
      //                         color: post.isLike ? Colors.red : null,
      //                       ),
      //                       const SizedBox(width: 4),
      //                       Text('${post.totalLikes} likes'),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       ),
    );
  }
}
