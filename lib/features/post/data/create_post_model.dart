// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  String code;
  String status;
  String message;
  String url;

  Post({
    required this.code,
    required this.status,
    required this.message,
    required this.url,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    code: json["code"],
    status: json["status"],
    message: json["message"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "message": message,
    "url": url,
  };
}
