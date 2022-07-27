import 'dart:async';
import 'dart:convert';

import 'package:backend/src/commons/services/jwt/jwt_service_interface.dart';
import 'package:backend/src/commons/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';

import '../../../commons/services/bcrypt/implementation/bcrypt_service.dart';
import '../domain/entities/user_entity.dart';
import '../domain/repositories/user_repository_interface.dart';

class AuthController {
  final RequestExtractor _requestExtractor;
  final IJwtService _jwtService;
  final BCryptService _bCrypt;
  final IUserRepository _userRepository;

  const AuthController({
    required RequestExtractor requestExtractor,
    required BCryptService bCrypt,
    required IUserRepository userRepository,
    required IJwtService jwtService,
  })  : _requestExtractor = requestExtractor,
        _bCrypt = bCrypt,
        _userRepository = userRepository,
        _jwtService = jwtService;

  FutureOr<Response> login(Request request) async {
    final credential = _requestExtractor.getAuthorizationBasic(request);
    if (credential == null) {
      return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
    }
    final user = await _userRepository.getByEmail(credential.email);

    final error = jsonEncode(
      {'error': 'Email ou senha invalidos'},
    );
    if (user == null) {
      return Response.forbidden(error);
    } else if (!_bCrypt.checkHash(credential.password, user.password)) {
      return Response.forbidden(error);
    } else {
      return Response.ok(jsonEncode(_generateToken(user)));
    }
  }

  FutureOr<Response> checkToken(Request request) async {
    final token = _requestExtractor.getAuthorizationBearer(request);
    if (token == null) {
      return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
    }
    final payload = _jwtService.getPayload(token);

    return Response.ok(jsonEncode(payload));
  }

  FutureOr<Response> refresh(Request request) async {
    final token = _requestExtractor.getAuthorizationBearer(request);
    if (token == null) {
      return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
    }
    final payload = _jwtService.getPayload(token);
    final user = await _userRepository.getById(payload['id']);
    if (user == null) {
      return Response.forbidden({'error': 'Email ou senha invalidos'});
    }

    return Response.ok(jsonEncode(_generateToken(user)));
  }

  Map<String, dynamic> _generateToken(UserEntity user) {
    final claims = user.toMap();
    claims['exp'] = _expiration(Duration(minutes: 10));
    final accessToken = _jwtService.generateToken(claims, 'accessToken');
    claims['exp'] = _expiration(Duration(days: 10));
    final refreshToken = _jwtService.generateToken(claims, 'refreshToken');

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    return Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
  }
}
