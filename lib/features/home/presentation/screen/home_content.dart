import 'package:flutter/material.dart';

import 'home_post_section.dart';
import 'home_story_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [HomeStorySection(), HomePostSection()],
      ),
    );
  }
}
