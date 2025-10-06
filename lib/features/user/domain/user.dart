class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? bio;
  final String? website;
  final int totalFollowing;
  final int totalFollowers;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    this.phoneNumber,
    this.bio,
    this.website,
    required this.totalFollowing,
    required this.totalFollowers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      profilePictureUrl: _parseStringField(json["profilePictureUrl"]),
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

class GetLoggedUserResponse {
  final String code;
  final String status;
  final String message;
  final User user;

  GetLoggedUserResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.user,
  });

  factory GetLoggedUserResponse.fromJson(Map<String, dynamic> json) {
    return GetLoggedUserResponse(
      code: json["code"].toString(),
      status: json["status"],
      message: json["message"],
      user: User.fromJson(json["data"]),
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
