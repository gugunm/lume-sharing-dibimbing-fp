import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/services/auth_storage_service.dart';
import 'package:fp_sharing_photo/features/auth/login/presentation/provider/login_provider.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';
import 'package:fp_sharing_photo/features/post/presentation/screen/user_post.dart';
import 'package:fp_sharing_photo/features/user/presentation/screen/user_page.dart';

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
  late final List<Widget> _pages;

  // Daftar title untuk setiap tab
  final List<String> _pageTitles = [
    'Home', // story
    'Explore',
    'Create Post', // Tidak akan ditampilkan karena navigasi terpisah
    'Connections',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(),
      _buildSearchPage(),
      const SizedBox.shrink(), // Placeholder untuk create post
      _buildNotificationsPage(),
      _buildProfilePage(),
    ];
  }

  // Widget untuk halaman Home
  Widget _buildHomePage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 100, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Konten feed posts akan ditampilkan di sini'),
        ],
      ),
    );
  }

  // Widget untuk halaman Search
  Widget _buildSearchPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 100, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Search Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Fitur pencarian akan ditampilkan di sini'),
        ],
      ),
    );
  }

  // Widget untuk halaman Notifications
  Widget _buildNotificationsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 100, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Notifications Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Notifikasi akan ditampilkan di sini'),
        ],
      ),
    );
  }

  // Widget untuk halaman Profile
  Widget _buildProfilePage() {
    if (userId != null) {
      return UserPostScreen(userId: userId!);
    }

    // Jika user sudah login, tampilkan UserPage atau profile content
    return const UserPage(); // Atau bisa diganti dengan widget profile yang sesuai
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
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]), // Title berubah sesuai tab
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40), // Simplified add button
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
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
