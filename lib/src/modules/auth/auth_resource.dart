import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'controllers/auth_controller.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/login', _login),
        Route.get('/refresh_token', _refreshToken),
        Route.get('/check_token', _checkToken),
        Route.post('/update_password', _updatePassword),
      ];

  FutureOr<Response> _login(Request request, Injector injector) {
    final controller = injector.get<AuthController>();

    return controller.login(request);
  }

  FutureOr<Response> _refreshToken(Injector injector) {
    final controller = injector.get<AuthController>();

    return Response.ok('');
  }

  FutureOr<Response> _checkToken(Injector injector) {
    final controller = injector.get<AuthController>();

    return Response.ok('');
  }

  FutureOr<Response> _updatePassword(Injector injector) {
    final controller = injector.get<AuthController>();

    return Response.ok('');
  }
}
