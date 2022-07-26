import 'package:shelf_modular/shelf_modular.dart';

import 'auth_resource.dart';
import 'controllers/auth_controller.dart';
import 'domain/repositories/user_repository_interface.dart';
import 'infra/data/user_repository.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory((i) => AuthController(
              bCrypt: i(),
              jwtService: i(),
              requestExtractor: i(),
              userRepository: i(),
            )),
        Bind.factory<IUserRepository>((i) => UserRepository(database: i()))
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
