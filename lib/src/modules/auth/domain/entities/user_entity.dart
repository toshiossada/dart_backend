import 'dart:convert';

import '../../../../commons/enums/role_enum.dart';

class UserEntity {
  final int id;
  final String name;
  final String email;
  final String password;
  final RoleEnum _role;



  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required RoleEnum role,
  }) : _role = role;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': _role.toString(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: toRoleEnum(map['role'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source));

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    RoleEnum? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? _role,
    );
  }
}
