import 'package:shelf_modular/shelf_modular.dart';

import 'swagger_handler.dart';

class SwaggerModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/**', swaggerHandler),
      ];
}
