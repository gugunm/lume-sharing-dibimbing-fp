class PostResponse {
  String code;
  String status;
  String message;
  Data data;

  PostResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
}

class Data {
  int totalItems;
  List<Post> posts;
  int totalPages;
  int currentPage;

  Data({
    required this.totalItems,
    required this.posts,
    required this.totalPages,
    required this.currentPage,
  });
}

class Post {
  String id;
  String userId;
  String imageUrl;
  String caption;
  bool isLike;
  int totalLikes;
  User user;
  DateTime createdAt;
  DateTime updatedAt;

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
}

class User {
  String id;
  String username;
  String email;
  String profilePictureUrl;
  DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });
}
