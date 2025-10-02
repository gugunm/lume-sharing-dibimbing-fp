import 'package:flutter/material.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 100, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Following Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Fitur following akan ditampilkan di sini'),
        ],
      ),
    );
  }
}
