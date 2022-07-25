import 'dart:async';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../dotenv_service.dart';
import '../models/result_model.dart';
import '../remote_database.dart';

class MysqlDatabase implements RemoteDatabase, Disposable {
  final DotEnvService dotenvService;
  final completer = Completer<MySQLConnection>();

  MysqlDatabase({
    required this.dotenvService,
  }) {
    _init();
  }

  _init() async {
    final conn = await MySQLConnection.createConnection(
      host: dotenvService.param('host'),
      port: int.parse(dotenvService.param('port')),
      userName: dotenvService.param('user'),
      password: dotenvService.param('password'),
      databaseName: dotenvService.param('db'),
    );
    await conn.connect();
    completer.complete(conn);
  }

  @override
  Future<ResultModel> query(String query,
      [Map<String, dynamic>? values]) async {
    try {
      final conn = await completer.future;

      var results = await conn.execute(query, values);

      final result = ResultModel(
        rows: results.rows.map((e) => e.typedAssoc()).toList(),
        affectedRows: results.affectedRows.toInt(),
        insertId: results.lastInsertID.toInt(),
        numOfRows: results.numOfRows,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    final conn = await completer.future;
    conn.close();
  }
}
