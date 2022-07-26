import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../services/jwt/dart_jsonwebtoken/jwt_service.dart';
import '../services/request_extractor/request_extractor.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  AuthGuard({this.roles = const [], this.isRefreshToken = false});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extrator = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) {
      if (!request.headers.containsKey('authorization')) {
        return Response.forbidden(
            jsonEncode({'error': 'not authorization header'}));
      }

      final token = extrator.getAuthorizationBearer(request);
      if (token == null) {
        return Response.forbidden(jsonEncode({'error': 'Token invalido'}));
      }
      try {
        jwt.verifyToken(token, isRefreshToken ? 'refreshToken' : 'accessToken');
        final payload = jwt.getPayload(token);
        final role = payload['role'] ?? 'user';

        if (roles.isEmpty || roles.contains(role)) {
          return handler(request);
        }

        return Response.forbidden(
            jsonEncode({'error': 'role ($role) not allowed'}));
      } catch (e) {
        return Response.forbidden(jsonEncode({'error': e.toString()}));
      }
    };
  }
}
