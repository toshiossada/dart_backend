import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'controller/user_controller.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _getAllUser),
        Route.post('/', _createUser),
        Route.get('/:id', _getUser),
        Route.put('/:id', _update),
        Route.delete('/:id', _delete),
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

  FutureOr<Response> _update(ModularArguments args, Injector injector) {
    final controller = injector.get<UserController>();

    return controller.update(args);
  }

  FutureOr<Response> _createUser(ModularArguments args, Injector injector) {
    final controller = injector.get<UserController>();

    return controller.createUser(args);
  }
}
