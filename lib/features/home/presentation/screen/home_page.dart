import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/features/connection/following/presentation/screen/follow_page.dart';
import 'package:fp_sharing_photo/features/explore/presentation/screen/explore_page.dart';
import 'package:fp_sharing_photo/features/post/presentation/screen/user_post.dart';

import 'home_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HomePageView();
  }
}

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({super.key});
  @override
  ConsumerState<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends ConsumerState<HomePageView> {
  final userId = AuthStorageService.getCurrentUser()?.id;
  int _selectedIndex = 0;

  // Daftar halaman untuk setiap tab
  final Map<int, Widget> _pageCache = {};

  // Method untuk membuat widget secara lazy (hanya saat dibutuhkan)
  Widget _buildPage(int index) {
    // Jika sudah ada di cache, gunakan yang ada
    if (_pageCache.containsKey(index)) {
      return _pageCache[index]!;
    }

    // Buat widget baru sesuai index
    Widget page;
    switch (index) {
      case 0:
        page = const HomeContent();
        break;
      case 1:
        page = const ExplorePage();
        break;
      case 2:
        page = const SizedBox.shrink(); // Placeholder untuk create post
        break;
      case 3:
        page = const FollowingPage();
        break;
      case 4:
        if (userId != null) {
          page = UserPostScreen(userId: userId!);
        } else {
          page = _buildLoginPrompt();
        }
        break;
      default:
        page = const SizedBox.shrink();
    }

    // Simpan ke cache
    _pageCache[index] = page;
    return page;
  }

  // Widget untuk prompt login jika user belum login
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Not Logged In',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text('Please login to view your profile'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(NavigationRoutes.authLogin.path);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to create post screen menggunakan route terpisah
      Navigator.pushNamed(context, NavigationRoutes.createPost.path);
      return;
    }

    // Untuk tab lainnya, update selectedIndex untuk mengubah konten
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Add this line
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
              _pageCache.clear();
            },
          ),
        ],
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40), // Simplified add button
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Connections',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
