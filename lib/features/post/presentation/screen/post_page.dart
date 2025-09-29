import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Just call logout - let AuthGuard handle the navigation
              await ref.read(authProvider.notifier).logout();
              // The AuthGuard will automatically redirect to login page
            },
          ),
        ],
      ),
      body: const Center(child: Text('Post Page')),
    );
  }
}
