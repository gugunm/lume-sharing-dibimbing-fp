class UserPost {
  final int totalItems;
  final List<Post> posts;
  final int totalPages;
  final int currentPage;

  UserPost({
    required this.totalItems,
    required this.posts,
    required this.totalPages,
    required this.currentPage,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) {
    List<Post> posts = [];
    final data = json["data"];

    try {
      if (data is List) {
        posts = data
            .map((x) => Post.fromJson(x as Map<String, dynamic>))
            .toList();
      } else if (data is Map<String, dynamic> && data.containsKey('posts')) {
        final nestedPosts = data['posts'] as List;
        posts = nestedPosts
            .map((x) => Post.fromJson(x as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error parsing posts: $e');
    }

    return UserPost(
      totalItems: json["totalItems"] ?? 0,
      posts: posts,
      totalPages: json["totalPages"] ?? 0,
      currentPage: json["currentPage"] ?? 1,
    );
  }
}

class Post {
  final String id;
  final String userId;
  final String imageUrl;
  final String caption;
  final bool isLike;
  final int totalLikes;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.isLike,
    required this.totalLikes,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      imageUrl: json["imageUrl"] ?? "",
      caption: json["caption"] ?? "",
      isLike: json["isLike"] ?? false,
      totalLikes: json["totalLikes"] ?? 0, // Handle null with default value
      user: User.fromJson(json["user"] ?? {}),
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final String profilePictureUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      profilePictureUrl: json["profilePictureUrl"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }
}
