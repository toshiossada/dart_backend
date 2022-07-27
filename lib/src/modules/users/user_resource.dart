import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../commons/middlewares/auth_guard.dart';
import 'controller/user_controller.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _getAllUser, middlewares: [AuthGuard()]),
        Route.post('/', _createUser),
        Route.get('/:id', _getUser, middlewares: [AuthGuard()]),
        Route.put('/:id', _update, middlewares: [AuthGuard()]),
        Route.delete('/:id', _delete, middlewares: [AuthGuard()]),
        Route.path('/:id/password', _updatePassword,
            middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _getAllUser(Injector injector) {
    final controller = injector.get<UserController>();

    return controller.getAllUser();
  }

  FutureOr<Response> _getUser(ModularArguments args, Injector injector) {
    final controller = injector.get<UserController>();

    return controller.getUser(args);
  }

  FutureOr<Response> _delete(ModularArguments args, Injector injector) {
    final controller = injector.get<UserController>();

    return controller.delete(args);
  }

  FutureOr<Response> _update(
      ModularArguments args, Injector injector, Request request) {
    final controller = injector.get<UserController>();

    return controller.update(args, request);
  }

  FutureOr<Response> _updatePassword(
      ModularArguments args, Injector injector, Request request) {
    final controller = injector.get<UserController>();

    return controller.updatePassword(args, request);
  }

  FutureOr<Response> _createUser(ModularArguments args, Injector injector) {
    final controller = injector.get<UserController>();

    return controller.createUser(args);
  }
}
