import 'dart:async';

import '../../../../commons/services/database/remote_database.dart';
import '../../domain/entities/user_enitity.dart';
import '../../domain/repositories/user_repository_interface.dart';

class UserRepository implements IUserRepository {
  final RemoteDatabase _database;

  UserRepository({
    required RemoteDatabase database,
  }) : _database = database;

  @override
  FutureOr<List<UserEntity>> getUsers() async {
    var query = '''
SELECT
	id,
	name,
    email,
    password,
    role
FROM User''';

    final result = await _database.query(query);
    if (result.rows.isEmpty) return [];

    var users = result.rows.map((e) => UserEntity.fromMap(e)).toList();

    return users;
  }

  @override
  FutureOr<UserEntity?> getUserById(int id) async {
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
      {"id": id},
    );
    if (result.rows.isEmpty) return null;

    var row = result.rows.first;

    var user = UserEntity.fromMap(row);

    return user;
  }
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
      {"email": email},
    );
    if (result.rows.isEmpty) return null;

    var row = result.rows.first;

    var user = UserEntity.fromMap(row);

    return user;
  }

  @override
  FutureOr<bool> delete(int id) async {
    var query = '''
DELETE FROM User
WHERE id = :id''';

    final result = await _database.query(
      query,
      {"id": id},
    );

    return (result.affectedRows ?? 0) > 0;
  }

  @override
  FutureOr<UserEntity> update(UserEntity user) async {
    var query = '''
UPDATE User
SET
    name = :name,
    email = :email,
    password = :password,
    role = :role
WHERE id = :id''';

    await _database.query(
      query,
      user.toMap(),
    );

    final newUser = await getUserById(user.id);

    return newUser!;
  }

  @override
  FutureOr<UserEntity?> insert(UserEntity user) async {
    var query = '''
INSERT INTO `dart_backend`.`User`
(name,
email,
password,
role)
VALUES
(:name,
:email,
:password,
:role);
''';

    var result = await _database.query(
      query,
      user.toMap(),
    );

    if ((result.insertId ?? 0) > 0) {
      final newUser = await getUserById(result.insertId!);

      return newUser;
    } else {
      return null;
    }
  }
}
