import 'package:hive/hive.dart';
import '../domain/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  // Konversi ke Entity (domain)
  User toEntity() => User(id: id, name: name, email: email);

  // Konversi dari JSON (API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // Provide default value
      // dummyjson.com menggunakan firstName dan lastName
      name: json.containsKey('firstName') && json['firstName'] != null
          ? '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim()
          : json['name']?.toString() ?? 'Unknown User',
      email: json['email']?.toString() ?? '',
    );
  }
}
