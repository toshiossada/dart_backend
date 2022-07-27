import 'dart:async';

import '../../domain/entities/user_enitity.dart';

abstract class IUserRepository {
  FutureOr<List<UserEntity>> getUsers();
  FutureOr<UserEntity?> getUserById(int id);
  FutureOr<bool> delete(int id);
  FutureOr<UserEntity> update(UserEntity user);
  FutureOr<UserEntity?> insert(UserEntity user);
  FutureOr<UserEntity?> getByEmail(String email);
  FutureOr<bool> updatePassword(int id, String password);
}
