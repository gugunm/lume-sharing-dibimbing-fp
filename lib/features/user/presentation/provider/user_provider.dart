// lib/features/user/presentation/user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/user_repository.dart';
import '../../domain/user.dart';

final userProvider = FutureProvider<List<User>>((ref) async {
  print('>>> UserProvider dipanggil');
  final repository = UserRepository();
  print('>>> UserRepository dipanggil');
  return await repository.getUsers();
});
