import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';

class PostPage extends ConsumerWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PostPageView();
  }
}

class PostPageView extends ConsumerStatefulWidget {
  const PostPageView({super.key});
  @override
  ConsumerState<PostPageView> createState() => _PostPageViewState();
}

class _PostPageViewState extends ConsumerState<PostPageView> {
  final userId = AuthStorageService.getCurrentUser()?.id;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SizedBox.shrink(), // Placeholder for center button (2)
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to create post screen using route
      Navigator.pushNamed(context, NavigationRoutes.createPost.path);
      return;
    }

    // Jika index 4 (Profile), arahkan ke user posts
    if (index == 4) {
      if (userId != null) {
        Navigator.of(context).pushNamed(
          NavigationRoutes.userPost.pathWithParams({'userId': userId!}),
        );
      } else {
        // User not logged in, redirect to login
        Navigator.of(
          context,
        ).pushReplacementNamed(NavigationRoutes.authLogin.path);
      }
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
