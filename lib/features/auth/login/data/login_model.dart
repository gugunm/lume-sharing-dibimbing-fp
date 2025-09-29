import 'dart:convert';
import 'package:hive/hive.dart';
import '../domain/login.dart';

part 'login_model.g.dart';

// Request Model
class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  // Convert dari domain entity
  factory LoginRequestModel.fromEntity(LoginRequest entity) {
    return LoginRequestModel(email: entity.email, password: entity.password);
  }

  // Convert ke JSON untuk API
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

// Response Model dengan Hive
@HiveType(typeId: 0)
class LoginResponseModel extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final UserModel user;

  @HiveField(4)
  final String token;

  LoginResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  // Convert dari JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      code: json['code']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      token: json['token']?.toString() ?? '',
    );
  }

  // Convert ke domain entity
  LoginResponse toEntity() {
    return LoginResponse(
      code: code,
      status: status,
      message: message,
      user: user.toEntity(),
      token: token,
    );
  }

  // Convert ke JSON untuk Hive storage
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'user': user.toJson(),
      'token': token,
    };
  }
}

// User Model untuk response login dengan Hive
@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String profilePictureUrl;

  @HiveField(6)
  final String phoneNumber;

  @HiveField(7)
  final String bio;

  @HiveField(8)
  final String website;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePictureUrl,
    required this.phoneNumber,
    required this.bio,
    required this.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      profilePictureUrl:
          json['profilePictureUrl']?.toString() ??
          json['profile_picture_url']?.toString() ??
          json['profilePicture']?.toString() ??
          json['avatar']?.toString() ??
          '',
      phoneNumber:
          json['phoneNumber']?.toString() ??
          json['phone_number']?.toString() ??
          json['phone']?.toString() ??
          '',
      bio: json['bio']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
    );
  }

  // Convert ke domain entity
  User toEntity() {
    return User(
      id: id,
      username: username,
      name: name,
      email: email,
      role: role,
      profilePictureUrl: profilePictureUrl,
      phoneNumber: phoneNumber,
      bio: bio,
      website: website,
    );
  }

  // Convert ke JSON (jika diperlukan untuk menyimpan ke local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'website': website,
    };
  }
}

// Helper functions untuk parsing JSON (optional)
LoginResponseModel loginResponseFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseToJson(LoginResponseModel data) =>
    json.encode(data.toEntity());

LoginRequestModel loginRequestFromJson(String str) =>
    LoginRequestModel.fromEntity(
      LoginRequest(
        email: json.decode(str)['email'],
        password: json.decode(str)['password'],
      ),
    );

String loginRequestToJson(LoginRequestModel data) => json.encode(data.toJson());
