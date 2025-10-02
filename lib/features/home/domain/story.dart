class StoryResponse {
  String code;
  String status;
  String message;
  Data data;

  StoryResponse({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });
}

class Data {
  int totalItems;
  List<Story> stories;
  int totalPages;
  int currentPage;

  Data({
    required this.totalItems,
    required this.stories,
    required this.totalPages,
    required this.currentPage,
  });
}

class Story {
  String id;
  String userId;
  String imageUrl;
  String caption;
  int totalViews;
  User user;
  DateTime createdAt;
  DateTime updatedAt;

  Story({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    required this.totalViews,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
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
