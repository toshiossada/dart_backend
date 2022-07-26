import 'package:dotenv/dotenv.dart';

class DotEnvService {
  DotEnvService([Map<String, dynamic>? mocks]) {
    if (mocks == null) {
      dotEnv = DotEnv()..load();
      _init(dotEnv: dotEnv);
    } else {
      _init(map: mocks);
    }
  }

  late final DotEnv dotEnv;

  _init({DotEnv? dotEnv, Map<String, dynamic>? map}) {
    if (dotEnv != null) {
      host = dotEnv['host'] ?? '';
      port = int.parse(dotEnv['port'] ?? '0');
      user = dotEnv['user'] ?? '';
      password = dotEnv['password'] ?? '';
      db = dotEnv['db'] ?? '';
      jwtKey = dotEnv['JWT_KEY'] ?? '';
    } else {
      host = map?['host'] ?? '';
      port = int.parse(map?['port'] ?? '0');
      user = map?['user'] ?? '';
      password = map?['password'] ?? '';
      db = map?['db'] ?? '';
      jwtKey = map?['JWT_KEY'] ?? '';
    }
  }

  late final String host;
  late final int port;
  late final String user;
  late final String password;
  late final String db;
  late final String jwtKey;
}
