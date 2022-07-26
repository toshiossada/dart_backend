import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../commons/middlewares/auth_guard.dart';
import 'controllers/auth_controller.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/login', _login),
        Route.get('/refresh_token', _refreshToken,
            middlewares: [AuthGuard(isRefreshToken: true)]),
        Route.get('/check_token', _checkToken, middlewares: [AuthGuard()]),
        Route.post('/update_password', _updatePassword,
            middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _login(Request request, Injector injector) {
    final controller = injector.get<AuthController>();

    return controller.login(request);
  }

  FutureOr<Response> _refreshToken(Request request, Injector injector) {
    final controller = injector.get<AuthController>();

    return controller.refresh(request);
  }

  FutureOr<Response> _checkToken(Injector injector) {
    final controller = injector.get<AuthController>();

    return Response.ok('ttt');
  }

  FutureOr<Response> _updatePassword(Injector injector) {
    final controller = injector.get<AuthController>();

    return Response.ok('');
  }
}
