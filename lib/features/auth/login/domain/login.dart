// Domain entities untuk Login
class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});
}

class LoginResponse {
  String code;
  String status;
  String message;
  User user;
  String token;

  LoginResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });
}

class User {
  String id;
  String username;
  String name;
  String email;
  String role;
  String profilePictureUrl;
  String phoneNumber;
  String bio;
  String website;

  User({
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
}
