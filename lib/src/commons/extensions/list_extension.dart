import 'dart:convert';

extension ListJson on List {
  toJson() => jsonEncode(map((e) => e.toMap()).toList());
}
