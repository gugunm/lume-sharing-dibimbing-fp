import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import 'package:fp_sharing_photo/features/post/presentation/provider/user_post_provider.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NavigationRoutes.updateUserProfile.path);
        },
        child: const Icon(Icons.manage_accounts),
      ),
      // Opsional: atur posisi FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
