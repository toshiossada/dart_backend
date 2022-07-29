import 'package:backend/src/commons/services/dotenv_service.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'services/bcrypt/bcrypt_service_interface.dart';
import 'services/bcrypt/implementation/bcrypt_service.dart';
import 'services/database/mysql/mysql_database.dart';
import 'services/database/remote_database.dart';
import 'services/jwt/dart_jsonwebtoken/jwt_service.dart';
import 'services/jwt/jwt_service_interface.dart';
import 'services/request_extractor/request_extractor.dart';

class CommonsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton<DotEnvService>((i) => DotEnvService(), export: true),
        Bind.singleton<RemoteDatabase>(
            (i) => MysqlDatabase(dotenvService: i<DotEnvService>()),
            export: true),
        Bind.singleton<IBCryptService>((i) => BCryptService(), export: true),
        Bind.singleton<IJwtService>((i) => JwtService(i()), export: true),
        Bind.singleton<RequestExtractor>((i) => RequestExtractor(),
            export: true),
      ];
}
