import 'package:flutter/material.dart';
import 'package:fp_sharing_photo/core/navigations/nav_routes.dart';

class PostNavigationHelper {
  /// Navigate to post detail page
  static void navigateToPostDetail(BuildContext context, String postId) {
    Navigator.pushNamed(
      context,
      NavigationRoutes.postDetail.pathWithParams({'postId': postId}),
    );
  }

  /// Navigate to user post page
  static void navigateToUserPosts(BuildContext context, String userId) {
    Navigator.pushNamed(
      context,
      NavigationRoutes.userPost.pathWithParams({'userId': userId}),
    );
  }
}