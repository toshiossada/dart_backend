import 'models/result_model.dart';

abstract class RemoteDatabase {
  Future<ResultModel> query(
    String query, [
    Map<String, dynamic>? values,
  ]);
}
