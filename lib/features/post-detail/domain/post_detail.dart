class PostDetailResponse {
  String code;
  String status;
  String message;
  PostDetail data;

  PostDetailResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
}

class PostDetail {
  String id;
  String userId;
  String imageUrl;
  String caption;
  bool isLike;
  int totalLikes;
  PostUser user;
  List<PostComment> comments;
  DateTime createdAt;
  DateTime updatedAt;

  PostDetail({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.isLike,
    required this.totalLikes,
    required this.user,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });
}

class PostUser {
  String id;
  String username;
  String email;
  String profilePictureUrl;
  DateTime createdAt;

  PostUser({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });
}

class PostComment {
  String id;
  String postId;
  String userId;
  String comment;
  PostUser user;
  DateTime createdAt;
  DateTime updatedAt;

  PostComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
}

class CreateCommentResponse {
  String code;
  String status;
  String message;
  PostComment data;

  CreateCommentResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
}