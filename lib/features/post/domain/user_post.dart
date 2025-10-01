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
    return UserPost(
      totalItems: json["totalItems"],
      posts: List<Post>.from(
        json["data"].map((x) => Post.fromJson(x)),
      ), // Ganti "posts" ke "data"
      totalPages: json["totalPages"],
      currentPage: json["currentPage"],
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
      id: json["id"],
      userId: json["userId"],
      imageUrl: json["imageUrl"],
      caption: json["caption"],
      isLike: json["isLike"],
      totalLikes: json["totalLikes"],
      user: User.fromJson(json["user"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
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
      id: json["id"],
      username: json["username"],
      email: json["email"],
      profilePictureUrl: json["profilePictureUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
