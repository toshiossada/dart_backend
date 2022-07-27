import 'dart:async';
import 'dart:convert';

import 'package:backend/src/commons/extensions/list_extension.dart';
import 'package:backend/src/modules/users/domain/entities/user_enitity.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../commons/services/bcrypt/bcrypt_service_interface.dart';
import '../../../commons/services/jwt/jwt_service_interface.dart';
import '../../../commons/services/request_extractor/request_extractor.dart';
import '../domain/repositories/user_repository_interface.dart';

class UserController {
  final IUserRepository _userRepository;
  final IBCryptService _bCryptService;
  final RequestExtractor _requestExtractor;
  final IJwtService _jwtService;

  UserController({
    required IUserRepository userRepository,
    required IBCryptService bCryptService,
    required RequestExtractor requestExtractor,
    required IJwtService jwtService,
  })  : _userRepository = userRepository,
        _bCryptService = bCryptService,
        _requestExtractor = requestExtractor,
        _jwtService = jwtService;

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

  FutureOr<Response> update(ModularArguments args, Request request) async {
    final token = _requestExtractor.getAuthorizationBearer(request);
    if (token == null) {
      return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
    }
    final payload = _jwtService.getPayload(token);

    final user = UserEntity.fromMap(args.data);
    final id = payload['id'];

    if (int.parse(args.params['id']) != id) {
      return Response.internalServerError(body: 'Id nao é o mesmo');
    }

    final foundUserEmail = await _userRepository.getByEmail(user.email);
    if (foundUserEmail != null && foundUserEmail.id != id) {
      return Response.internalServerError(
        body: 'Email ja cadastrado em outro usuario',
      );
    }
    final hashedUser = user.copyWith(
      password: _bCryptService.gernerateHase(user.password),
      id: id,
    );
    final updated = await _userRepository.update(hashedUser);
    return Response.ok(updated.toJson());
  }

  FutureOr<Response> updatePassword(
      ModularArguments args, Request request) async {
    final token = _requestExtractor.getAuthorizationBearer(request);
    if (token == null) {
      return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
    }
    final payload = _jwtService.getPayload(token);

    final id = payload['id'];

    if (int.parse(args.params['id']) != id) {
      return Response.internalServerError(body: 'Id nao é o mesmo');
    }

    final foundUserEmail = await _userRepository.getUserById(id);

    if (foundUserEmail == null) {
      return Response.notFound('Usuario nao encontrado');
    }

    final newPassword = args.data['password'];
    final hashedUser = foundUserEmail.copyWith(
      password: _bCryptService.gernerateHase(newPassword),
      id: id,
    );
    final updated = await _userRepository.update(hashedUser);
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
