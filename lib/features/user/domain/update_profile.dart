class UpdateProfileRequest {
  final String name;
  final String username;
  final String email;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? bio;
  final String? website;

  UpdateProfileRequest({
    required this.name,
    required this.username,
    required this.email,
    this.profilePictureUrl,
    this.phoneNumber,
    this.bio,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "email": email,
      "profilePictureUrl": profilePictureUrl,
      "phoneNumber": phoneNumber,
      "bio": bio,
      "website": website,
    };
  }

  // Optional: fromJson jika kamu ingin parsing dari response
  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequest(
      name: json["name"],
      username: json["username"],
      email: json["email"],
      profilePictureUrl: json["profilePictureUrl"],
      phoneNumber: json["phoneNumber"],
      bio: json["bio"],
      website: json["website"],
    );
  }
}
