class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({required this.id, required this.name, required this.email});

  String get firstName {
    final t = name.trim();
    return t.isEmpty ? 'there' : t.split(' ').first;
  }

  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}
