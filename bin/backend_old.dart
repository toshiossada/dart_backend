import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final app = Router();
  app.get('/', _handleInitial);
  app.get('/user', _handleUser);
  app.post('/user', _handlePostUser);
  app.get('/teste', _handleTest);

  final pipeline = Pipeline() //
      .addMiddleware(logRequests())
      .addMiddleware(addJsonType())
      .addHandler(app);

  var server = await shelf_io.serve(
    pipeline,
    'localhost',
    8080,
  );

  print('Serving at http://${server.address.host}:${server.port}');
}

Middleware addJsonType() {
  return (handle) {
    return (request) async {
      var response = await handle(request);

      response = response.change(headers: {
        'content-type': 'application/json',
      });
      return response;
    };
  };
}

Response _handleInitial(Request request) {
  return Response.ok('''{
    messagss: 'Rota inicial'
    }''');
}

Response _handleUser(Request request) {
  return Response.ok('''{
    messagss: 'Usuario'
    }''');
}

Response _handlePostUser(Request request) {
  return Response(201, body: '''{
    messagss: 'Criado'
    }''');
}

Response _handleTest(Request request) {
  return Response.ok('''{
    messagss: 'Teste'
    }''');
}
