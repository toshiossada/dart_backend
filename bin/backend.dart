import 'package:backend/backend.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  final handler = await startShelfModular();
  var server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
