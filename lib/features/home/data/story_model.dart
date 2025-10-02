import '../domain/story.dart';

class StoryModelResponse {
  String code;
  String status;
  String message;
  DataModel data;

  StoryModelResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  StoryResponse toEntity() => StoryResponse(
    code: code,
    status: status,
    message: message,
    data: data.toEntity(),
  );

  factory StoryModelResponse.fromJson(Map<String, dynamic> json) =>
      StoryModelResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: DataModel.fromJson(json["data"]),
      );
}

class DataModel {
  int totalItems;
  List<StoryModel> stories;
  int totalPages;
  int currentPage;

  DataModel({
    required this.totalItems,
    required this.stories,
    required this.totalPages,
    required this.currentPage,
  });

  Data toEntity() => Data(
    totalItems: totalItems,
    stories: stories.map((story) => story.toEntity()).toList(),
    totalPages: totalPages,
    currentPage: currentPage,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    totalItems: json["totalItems"],
    stories: List<StoryModel>.from(
      json["stories"].map((x) => StoryModel.fromJson(x)),
    ),
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );
}

class StoryModel {
  String id;
  String userId;
  String imageUrl;
  String caption;
  int totalViews;
  UserModel user;
  DateTime createdAt;
  DateTime updatedAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.totalViews,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Story toEntity() => Story(
    id: id,
    userId: userId,
    imageUrl: imageUrl,
    caption: caption,
    totalViews: totalViews,
    user: user.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
    id: json["id"],
    userId: json["userId"],
    imageUrl: json["imageUrl"],
    caption: json["caption"],
    totalViews: json["totalViews"],
    user: UserModel.fromJson(json["user"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
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
    id: json["id"],
    username: json["username"],
    email: json["email"],
    profilePictureUrl: json["profilePictureUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
  );
}
