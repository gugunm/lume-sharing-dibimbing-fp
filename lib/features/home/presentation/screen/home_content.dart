import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';

import 'home_post_section.dart';
import 'home_story_section.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // color: Colors.black87,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 32, // Control logo size
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Lume Share',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            // Text(_pageTitles[_selectedIndex]),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              // Clear cache setelah logout
              // _pageCache.clear();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [HomeStorySection(), HomePostSection()],
          ),
        ),
      ),
    );
  }
}
