import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'src/app_module.dart';

Future<Handler> startShelfModular() async {
  final modularHandler = Modular(
    module: AppModule(), // Initial Module
    middlewares: [
      logRequests(), // Middleware Pipeline
      addJsonType(),
    ],
  );

  return modularHandler;
}

Middleware addJsonType() {
  return (handle) {
    return (request) async {
      //Before
      var response = await handle(request);
      //After

      response = response.change(headers: {
        'content-type': 'application/json',
        ...response.headers,
      });

      return response;
    };
  };
}
