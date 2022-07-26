
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../dotenv_service.dart';
import '../jwt_service_interface.dart';

class JwtService implements IJwtService {
  final DotEnvService dotEnvService;

  JwtService(this.dotEnvService);

  @override
  String generateToken(Map claims, String audiance) {
    final jwt = JWT(claims, audience: Audience.one(audiance));
    final token = jwt.sign(SecretKey(dotEnvService.jwtKey));
    return token;
  }

  @override
  void verifyToken(String token, String audiance) {
    JWT.verify(
      token,
      SecretKey(dotEnvService.jwtKey),
      audience: Audience.one(audiance),
    );
  }

  @override
  Map getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(dotEnvService.jwtKey),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }
}