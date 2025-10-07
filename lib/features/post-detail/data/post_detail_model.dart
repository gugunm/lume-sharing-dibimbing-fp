import '../domain/post_detail.dart';

class PostDetailModelResponse {
  String code;
  String status;
  String message;
  PostDetailModel data;

  PostDetailModelResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  PostDetailResponse toEntity() => PostDetailResponse(
    code: code,
    status: status,
    message: message,
    data: data.toEntity(),
  );

  factory PostDetailModelResponse.fromJson(Map<String, dynamic> json) =>
      PostDetailModelResponse(
        code: json["code"] ?? "",
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: PostDetailModel.fromJson(json["data"] ?? {}),
      );
}

class PostDetailModel {
  String id;
  String userId;
  String imageUrl;
  String caption;
  bool isLike;
  int totalLikes;
  PostUserModel user;
  List<PostCommentModel> comments;
  DateTime createdAt;
  DateTime updatedAt;

  PostDetailModel({
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

  PostDetail toEntity() => PostDetail(
    id: id,
    userId: userId,
    imageUrl: imageUrl,
    caption: caption,
    isLike: isLike,
    totalLikes: totalLikes,
    user: user.toEntity(),
    comments: comments.map((comment) => comment.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PostDetailModel.fromJson(Map<String, dynamic> json) => PostDetailModel(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    caption: json["caption"] ?? "",
    isLike: json["isLike"] ?? false,
    totalLikes: json["totalLikes"] ?? 0,
    user: PostUserModel.fromJson(json["user"] ?? {}),
    comments: json["comments"] != null
        ? List<PostCommentModel>.from(json["comments"].map((x) => PostCommentModel.fromJson(x)))
        : [],
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
  );
}

class PostUserModel {
  String id;
  String username;
  String email;
  String profilePictureUrl;
  DateTime createdAt;

  PostUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });

  PostUser toEntity() => PostUser(
    id: id,
    username: username,
    email: email,
    profilePictureUrl: profilePictureUrl,
    createdAt: createdAt,
  );

  factory PostUserModel.fromJson(Map<String, dynamic> json) => PostUserModel(
    id: json["id"] ?? "",
    username: json["username"] ?? "",
    email: json["email"] ?? "",
    profilePictureUrl: json["profilePictureUrl"] ?? "",
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "profilePictureUrl": profilePictureUrl,
    "createdAt": createdAt.toIso8601String(),
  };
}

class PostCommentModel {
  String id;
  String postId;
  String userId;
  String comment;
  PostUserModel user;
  DateTime createdAt;
  DateTime updatedAt;

  PostCommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  PostComment toEntity() => PostComment(
    id: id,
    postId: postId,
    userId: userId,
    comment: comment,
    user: user.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PostCommentModel.fromJson(Map<String, dynamic> json) => PostCommentModel(
    id: json["id"] ?? "",
    postId: json["postId"] ?? "",
    userId: json["userId"] ?? "",
    comment: json["comment"] ?? "",
    user: PostUserModel.fromJson(json["user"] ?? {}),
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "postId": postId,
    "userId": userId,
    "comment": comment,
    "user": user.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class CreateCommentModelResponse {
  String code;
  String status;
  String message;
  PostCommentModel data;

  CreateCommentModelResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  CreateCommentResponse toEntity() => CreateCommentResponse(
    code: code,
    status: status,
    message: message,
    data: data.toEntity(),
  );

  factory CreateCommentModelResponse.fromJson(Map<String, dynamic> json) =>
      CreateCommentModelResponse(
        code: json["code"] ?? "",
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: PostCommentModel.fromJson(json["data"] ?? {}),
      );
}