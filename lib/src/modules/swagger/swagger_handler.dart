import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

FutureOr<Response> swaggerHandler(Request request) {
  final path = 'specs/swagger.yaml';
  final handler = SwaggerUI(
    path,
    title: 'Semana do Backend',
    deepLink: true,
  );
  return handler(request);
}
