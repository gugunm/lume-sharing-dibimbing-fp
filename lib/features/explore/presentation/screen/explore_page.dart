import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 100, color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Explore Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Fitur pencarian akan ditampilkan di sini'),
        ],
      ),
    );
  }
}
