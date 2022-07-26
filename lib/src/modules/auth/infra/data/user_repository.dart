import 'dart:async';

import '../../../../commons/services/database/remote_database.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository_interface.dart';

class UserRepository implements IUserRepository {
  final RemoteDatabase _database;

  UserRepository({
    required RemoteDatabase database,
  }) : _database = database;

  @override
  FutureOr<UserEntity?> getByEmail(String email) async {
    var query = '''
SELECT
	id,
	name,
    email,
    password,
    role
FROM User
WHERE email = :email''';

    final result = await _database.query(
      query,
      {
        "email": email,
      },
    );
    if (result.rows.isEmpty) return null;

    var row = result.rows.first;
    var user = UserEntity.fromMap(row);

    return user;
  }

  @override
  FutureOr<UserEntity?> getById(int id) async {
    var query = '''
SELECT
	id,
	name,
    email,
    password,
    role
FROM User
WHERE id = :id''';

    final result = await _database.query(
      query,
      {
        "id": id,
      },
    );
    if (result.rows.isEmpty) return null;

    var row = result.rows.first;
    var user = UserEntity.fromMap(row);

    return user;
  }
}
