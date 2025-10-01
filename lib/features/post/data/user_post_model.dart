// To parse this JSON data, do
//
//     final userPost = userPostFromJson(jsonString);

import 'dart:convert';

UserPost userPostFromJson(String str) => UserPost.fromJson(json.decode(str));

String userPostToJson(UserPost data) => json.encode(data.toJson());

class UserPost {
  int totalItems;
  List<Post> posts;
  int totalPages;
  int currentPage;

  UserPost({
    required this.totalItems,
    required this.posts,
    required this.totalPages,
    required this.currentPage,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) => UserPost(
    totalItems: json["totalItems"],
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
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

  factory Post.fromJson(Map<String, dynamic> json) => Post(
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

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "imageUrl": imageUrl,
    "caption": caption,
    "isLike": isLike,
    "totalLikes": totalLikes,
    "user": user.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
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

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    profilePictureUrl: json["profilePictureUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "profilePictureUrl": profilePictureUrl,
    "createdAt": createdAt.toIso8601String(),
  };
}
