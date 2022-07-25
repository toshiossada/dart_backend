import 'package:backend/src/commons/services/dotenv_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'commons/services/bcrypt/bcrypt_service_interface.dart';
import 'commons/services/bcrypt/implementation/bcrypt_service.dart';
import 'commons/services/database/mysql/mysql_database.dart';
import 'commons/services/database/remote_database.dart';
import 'modules/swagger/swagger_module.dart';
import 'modules/users/user_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService()),
        Bind.singleton<RemoteDatabase>(
            (i) => MysqlDatabase(dotenvService: i<DotEnvService>())),
        Bind.singleton<IBCryptService>((i) => BCryptService()),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', () => Response.ok('OK!')),
        Route.module('/user', module: UserModule()),
        Route.module('/swagger', module: SwaggerModule()),
      ];
}
