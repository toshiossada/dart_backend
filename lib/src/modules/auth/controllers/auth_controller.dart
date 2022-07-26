import 'dart:async';
import 'dart:convert';

import 'package:backend/src/commons/services/jwt/jwt_service_interface.dart';
import 'package:backend/src/commons/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';

import '../../../commons/services/bcrypt/implementation/bcrypt_service.dart';
import '../domain/repositories/user_repository_interface.dart';

class AuthController {
  final RequestExtractor _requestExtractor;
  final BCryptService _bCrypt;
  final IUserRepository _userRepository;
  final IJwtService _jwtService;
  AuthController({
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

    final user = await _userRepository.getByEmail(credential?.email ?? '');

    final error = jsonEncode(
      {'error': 'Email ou senha invalidos'},
    );
    if (user == null) {
      return Response.forbidden(error);
    } else if (!_bCrypt.checkHash(credential?.password ?? '', user.password)) {
      return Response.forbidden(error);
    } else {
      final claims = user.toMap();
      claims['exp'] = _expiration(Duration(minutes: 10));
      final accessToken = _jwtService.generateToken(claims, 'accessToken');
      claims['exp'] = _expiration(Duration(days: 10));
      final refreshToken = _jwtService.generateToken(claims, 'refreshToken');

      return Response.ok(jsonEncode(
        {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        },
      ));
    }
  }

  int _expiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    return Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;
  }
}
