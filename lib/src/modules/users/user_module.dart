import 'package:backend/src/modules/users/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'domain/repositories/user_repository_interface.dart';
import 'infra/data/user_repository.dart';
import 'controller/user_controller.dart';

class UserModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<UserController>((i) => UserController(
              userRepository: i(),
              bCryptService: i(),
            )),
        Bind.factory<IUserRepository>((i) => UserRepository(database: i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(UserResource()),
      ];
}
