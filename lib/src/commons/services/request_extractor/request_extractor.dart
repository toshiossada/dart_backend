import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'models/login_credential.dart';

class RequestExtractor {
  String? getAuthorizationBearer(Request request) {
    final authorization = request.headers['authorization'] ?? '';

    final parts = authorization.split(' ');
    if (parts.length != 2 || parts[0].toLowerCase() != 'bearer') {
      return null;
    }
    return parts.last;
  }

  LoginCredential? getAuthorizationBasic(Request request) {
    var authorization = request.headers['authorization'] ?? '';

    final parts = authorization.split(' ');
    if (parts.length != 2 || parts[0].toLowerCase() != 'basic') {
      return null;
    }
    authorization = authorization.split(' ').last;
    authorization = String.fromCharCodes(base64Decode(authorization));
    final credential = authorization.split(':');
    return LoginCredential(
      email: credential.first,
      password: credential.last,
    );
  }
}
