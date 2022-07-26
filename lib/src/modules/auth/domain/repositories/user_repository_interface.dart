import 'dart:async';

import '../entities/user_entity.dart';

abstract class IUserRepository {
  FutureOr<UserEntity?> getByEmail(String email);
  FutureOr<UserEntity?> getById(int id);
}
