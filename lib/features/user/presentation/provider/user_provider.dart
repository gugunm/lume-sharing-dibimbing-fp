// lib/features/user/presentation/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/user_repository.dart';
import '../../domain/user.dart';

final userProvider = FutureProvider<List<User>>((ref) async {
  try {
    final repository = UserRepository();
    final users = await repository.getUsers();
    return users;
  } catch (e) {
    print('Error in userProvider: $e');
    return <User>[]; // Return empty list instead of throwing
  }
});
