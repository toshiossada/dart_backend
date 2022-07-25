import 'dart:convert';

import 'package:backend/src/modules/users/domain/entities/role_enum.dart';

class UserEntity {
  final int id;
  final String name;
  final String password;
  final String email;
  final RoleEnum _role;

  static RoleEnum toEnum(String str) {
    switch (str) {
      case 'admin':
        return RoleEnum.admin;
      case 'user':
        return RoleEnum.user;
      case 'manager':
      default:
        return RoleEnum.manager;
    }
  }

  UserEntity({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required RoleEnum role,
  }) : _role = role;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': _role.toString(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: toEnum(map['role'] ?? ''),
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
      password: password ?? this.password,
      email: email ?? this.email,
      role: role ?? _role,
    );
  }
}
