import '../domain/explore.dart';

class ExploreModelResponse {
  String code;
  String status;
  String message;
  DataModel data;

  ExploreModelResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  ExploreResponse toEntity() => ExploreResponse(
    code: code,
    status: status,
    message: message,
    data: data.toEntity(),
  );

  factory ExploreModelResponse.fromJson(Map<String, dynamic> json) =>
      ExploreModelResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: DataModel.fromJson(json["data"]),
      );
}

class DataModel {
  int totalItems;
  List<PostModel> posts;
  int totalPages;
  int currentPage;

  DataModel({
    required this.totalItems,
    required this.posts,
    required this.totalPages,
    required this.currentPage,
  });

  Data toEntity() => Data(
    totalItems: totalItems,
    posts: posts.map((post) => post.toEntity()).toList(),
    totalPages: totalPages,
    currentPage: currentPage,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    totalItems: json["totalItems"] ?? 0,
    posts: json["posts"] != null
        ? List<PostModel>.from(json["posts"].map((x) => PostModel.fromJson(x)))
        : [],
    totalPages: json["totalPages"] ?? 0,
    currentPage: json["currentPage"] ?? 0,
  );
}

class PostModel {
  String id;
  String userId;
  String imageUrl;
  String caption;
  bool isLike;
  int totalLikes;
  UserModel user;
  DateTime createdAt;
  DateTime updatedAt;

  PostModel({
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

  Post toEntity() => Post(
    id: id,
    userId: userId,
    imageUrl: imageUrl,
    caption: caption,
    isLike: isLike,
    totalLikes: totalLikes,
    user: user.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"] ?? "",
    userId: json["userId"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    caption: json["caption"] ?? "",
    isLike: json["isLike"] ?? false,
    totalLikes: json["totalLikes"] ?? 0,
    user: json["user"] != null
        ? UserModel.fromJson(json["user"])
        : UserModel(
            id: "",
            username: "Unknown",
            email: "",
            profilePictureUrl: "",
            createdAt: DateTime.now(),
          ),
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
    updatedAt: json["updatedAt"] != null
        ? DateTime.parse(json["updatedAt"])
        : DateTime.now(),
  );
}

class UserModel {
  String id;
  String username;
  String email;
  String profilePictureUrl;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });

  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    profilePictureUrl: profilePictureUrl,
    createdAt: createdAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"] ?? "",
    username: json["username"] ?? "Unknown",
    email: json["email"] ?? "",
    profilePictureUrl: json["profilePictureUrl"] ?? "",
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : DateTime.now(),
  );
}
