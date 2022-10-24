// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:http/http.dart';

class Logger {
  Logger(this.method, this.url);

  final String method;
  final String url;

  void request(Object data) {
    _divider();
    _logHeading();
    _log(
      data.toString(),
      name: method == 'GET' ? 'Query Parameters' : 'Request Data',
    );
    _divider();
  }

  void response(Response response) {
    _divider();
    _logHeading();
    _log(response.statusCode.toString(), name: 'Response Status Code');
    _log(response.body, name: 'Response Body');
    _divider();
  }

  void _logHeading() => _log(url, name: method);

  void _log(String message, {@required String name}) {
    print('[$name] $message');
  }

  void _divider() {
    print('-' * 140);
  }
}
