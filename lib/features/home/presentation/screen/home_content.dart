import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, size: 100, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Home Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Konten posts akan ditampilkan di sini'),
        ],
      ),
    );
  }
}
