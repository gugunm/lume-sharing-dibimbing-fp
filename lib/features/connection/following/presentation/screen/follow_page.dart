import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
    );
  }

  Widget _buildFollowersList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 100, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Followers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Daftar followers akan ditampilkan di sini',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add, size: 100, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Following',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Daftar following akan ditampilkan di sini',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
