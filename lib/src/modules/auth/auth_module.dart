import 'package:shelf_modular/shelf_modular.dart';

import 'auth_resource.dart';
import 'controllers/auth_controller.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory((i) => AuthController()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
