import '../domain/following.dart';

class FollowingModelResponse {
  String code;
  String status;
  String message;
  DataModel data;

  FollowingModelResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  FollowingResponse toEntity() => FollowingResponse(
    code: code,
    status: status,
    message: message,
    data: data.toEntity(),
  );

  factory FollowingModelResponse.fromJson(Map<String, dynamic> json) =>
      FollowingModelResponse(
        code: json["code"],
        status: json["status"],
        message: json["message"],
        data: DataModel.fromJson(json["data"]),
      );
}

class DataModel {
  int totalItems;
  List<UserModel> users;
  int totalPages;
  int currentPage;

  DataModel({
    required this.totalItems,
    required this.users,
    required this.totalPages,
    required this.currentPage,
  });

  Data toEntity() => Data(
    totalItems: totalItems,
    users: users.map((user) => user.toEntity()).toList(),
    totalPages: totalPages,
    currentPage: currentPage,
  );

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    totalItems: json["totalItems"],
    users: List<UserModel>.from(
      json["users"].map((x) => UserModel.fromJson(x)),
    ),
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
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
