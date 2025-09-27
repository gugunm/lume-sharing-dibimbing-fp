// lib/features/user/domain/user.dart

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  // Opsional: factory untuk konversi dari model (nanti dipakai di repository)
  // Tapi biasanya konversi dilakukan di model, bukan di entity
}
