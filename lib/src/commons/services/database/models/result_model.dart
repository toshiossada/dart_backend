class ResultModel {
  final int? insertId;
  final int? affectedRows;
  final int? numOfRows;
  final List<Map<String, dynamic>> rows;

  ResultModel({
    this.insertId,
    this.affectedRows,
    this.numOfRows,
    required this.rows,
  });
}
