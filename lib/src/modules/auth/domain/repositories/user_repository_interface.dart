import 'dart:async';

import '../../../../commons/services/request_extractor/models/login_credential.dart';
import '../entities/user_entity.dart';

abstract class IUserRepository {
  FutureOr<UserEntity?> getByEmail(String email);
}
