import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/story_provider.dart';

class HomeStorySection extends ConsumerStatefulWidget {
  const HomeStorySection({super.key});

  @override
  ConsumerState<HomeStorySection> createState() => _HomeStorySectionState();
}

class _HomeStorySectionState extends ConsumerState<HomeStorySection> {
  @override
  void initState() {
    super.initState();
    // Load stories when widget starts
    Future.microtask(() {
      ref.read(storyProvider.notifier).loadInitialStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final storyState = ref.watch(storyProvider);

    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      // margin: EdgeInsets.only(left: 8),
      child: Column(children: [Expanded(child: _buildContent(storyState))]),
    );
  }

  Widget _buildContent(StoryState state) {
    // Loading
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Error
    if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    }

    // Empty
    if (state.stories.isEmpty) {
      return Center(child: Text('No stories'));
    }

    // Stories list
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.stories.length,
      itemBuilder: (context, index) {
        final story = state.stories[index];
        return Container(
          width: 60,
          margin: EdgeInsets.all(4),
          child: Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(story.user.profilePictureUrl),
              ),
              Text(
                story.user.username,
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
