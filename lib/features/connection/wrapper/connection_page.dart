import 'package:flutter/material.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';

import '../followers/presentation/screen/follower_page.dart';
import '../following/presentation/screen/following_page.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationRoutes.home.path,
              (route) => false,
            );
          },
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Followers'),
                  Tab(text: 'Following'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Followers Tab
                    _buildFollowersList(),
                    // Following Tab
                    _buildFollowingList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowersList() {
    return FollowerPage();
  }

  Widget _buildFollowingList() {
    return FollowingPage();
  }
}
