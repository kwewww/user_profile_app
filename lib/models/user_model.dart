import 'dart:convert';

/// A user account stored locally by this sample application.
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  String get initials {
    final nameParts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (nameParts.isEmpty) return '?';

    return nameParts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'createdAt': createdAt.toIso8601String(),
  };

  String toJson() => jsonEncode(toMap());

  factory UserModel.fromJson(String source) {
    final data = jsonDecode(source) as Map<String, dynamic>;
    return UserModel(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      password: data['password'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }
}
