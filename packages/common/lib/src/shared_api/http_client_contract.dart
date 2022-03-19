import 'package:flutter/foundation.dart';

abstract class IHttpClient {
  Future<HttpResult> get(Uri url, {Map<String, String> headers});
  Future<HttpResult> post(Uri url, String, String body,
      {Map<String, String> headers});
}

class HttpResult {
  final String? data;
  final Status? status;

  HttpResult({@required this.data, @required this.status});
}

enum Status { success, failure }
