class FollowerResponse {
  String code;
  String status;
  String message;
  Data data;

  FollowerResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
}

class Data {
  int totalItems;
  List<User> users;
  int totalPages;
  int currentPage;

  Data({
    required this.totalItems,
    required this.users,
    required this.totalPages,
    required this.currentPage,
  });
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
}
