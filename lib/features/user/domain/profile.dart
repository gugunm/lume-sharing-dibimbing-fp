class UserProfile {
  final String id;
  final String name;
  final String username;
  final String email;
  final String profilePictureUrl;
  final String? phoneNumber;
  final String? bio;
  final String? website;
  final int totalFollowing;
  final int totalFollowers;

  UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    this.phoneNumber,
    this.bio,
    this.website,
    required this.totalFollowing,
    required this.totalFollowers,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      profilePictureUrl: json["profilePictureUrl"] ?? "",
      phoneNumber: _parseStringField(json["phoneNumber"]),
      bio: _parseStringField(json["bio"]),
      website: _parseStringField(json["website"]),
      totalFollowing: json["totalFollowing"] ?? 0,
      totalFollowers: json["totalFollowers"] ?? 0,
    );
  }

  static String? _parseStringField(dynamic value) {
    if (value == null) return null;
    if (value == "") return null;
    if (value == "0") return null;
    if (value is String) return value;
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
      "phoneNumber": phoneNumber,
      "bio": bio,
      "website": website,
      "totalFollowing": totalFollowing,
      "totalFollowers": totalFollowers,
    };
  }
}

class GetLoggedUserProfileResponse {
  final String code;
  final String status;
  final String message;
  final UserProfile user;

  GetLoggedUserProfileResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.user,
  });

  factory GetLoggedUserProfileResponse.fromJson(Map<String, dynamic> json) {
    return GetLoggedUserProfileResponse(
      code: json["code"].toString(),
      status: json["status"],
      message: json["message"],
      user: UserProfile.fromJson(json["data"]), // Response pakai wrapper "data"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "status": status,
      "message": message,
      "user": user.toJson(),
    };
  }
}
