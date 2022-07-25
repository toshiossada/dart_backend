import 'dart:async';

import 'package:backend/src/commons/extensions/list_extension.dart';
import 'package:backend/src/modules/users/domain/entities/user_enitity.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../commons/services/bcrypt/bcrypt_service_interface.dart';
import '../domain/repositories/user_repository_interface.dart';

class UserController {
  final IUserRepository _userRepository;
  final IBCryptService _bCryptService;

  UserController({
    required IUserRepository userRepository,
    required IBCryptService bCryptService,
  })  : _userRepository = userRepository,
        _bCryptService = bCryptService;

  FutureOr<Response> getAllUser() async {
    final users = await _userRepository.getUsers();

    return Response.ok(users.toJson());
  }

  FutureOr<Response> getUser(ModularArguments args) async {
    final id = int.parse(args.params['id']);
    final user = await _userRepository.getUserById(id);
    if (user == null) return Response.notFound('Usuario nao encontrado');

    return Response.ok(user.toJson());
  }

  FutureOr<Response> delete(ModularArguments args) async {
    final id = int.parse(args.params['id']);
    final user = await _userRepository.getUserById(id);
    if (user == null) return Response.notFound('Usuario nao encontrado');

    final deleted = await _userRepository.delete(id);
    if (!deleted) {
      return Response.internalServerError();
    } else {
      return Response.ok('Usuario deletado com sucesso');
    }
  }

  FutureOr<Response> update(ModularArguments args) async {
    final user = UserEntity.fromMap(args.data);
    final id = int.parse(args.params['id']);
    final foundUser = await _userRepository.getUserById(id);
    if (foundUser == null) return Response.notFound('Usuario nao encontrado');
    final foundUserEmail = await _userRepository.getByEmail(user.email);
    if (foundUserEmail != null && foundUserEmail.id != id) {
      return Response.internalServerError(
        body: 'Email ja cadastrado em outro usuario',
      );
    }

    final updated = await _userRepository.update(user.copyWith(id: id));
    return Response.ok(updated.toJson());
  }

  FutureOr<Response> createUser(ModularArguments args) async {
    final user = UserEntity.fromMap(args.data);
    final foundUser = await _userRepository.getByEmail(user.email);
    if (foundUser != null) {
      return Response.internalServerError(
        body: 'Email ja cadastrado',
      );
    }

    final hashedUser =
        user.copyWith(password: _bCryptService.gernerateHase(user.password));
    final inserted = await _userRepository.insert(hashedUser);

    if (inserted == null) {
      return Response.internalServerError();
    }

    return Response.ok(inserted.toJson());
  }
}
