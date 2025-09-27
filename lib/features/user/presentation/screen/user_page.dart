// lib/features/user/presentation/user_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import '../provider/user_provider.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userProvider);

    // print('>>> ${usersAsync}');

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: usersAsync.when(
        loading: () => const GlobalLoadingWidget(),
        error: (error, stack) => Center(child: Text('Gagal: $error')),
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(user.email),
            );
          },
        ),
      ),
    );
  }
}
